import { useState, useEffect } from 'react';
import Head from 'next/head';
import { ethers } from 'ethers';

const EDUSD_ADDRESS = '0x88CE6C21c53A602A3333C5970DB703Fb9e0dDBF6';

export default function Home() {
  const [currentPrice, setCurrentPrice] = useState(1.00);
  const [isWalletConnected, setIsWalletConnected] = useState(false);
  const [walletAddress, setWalletAddress] = useState('');
  const [circulatingSupply, setCirculatingSupply] = useState(4);

  useEffect(() => {
    const fetchData = async () => {
      // Simulate fetching current price
      setCurrentPrice(1.00);
    };

    fetchData();
    const interval = setInterval(fetchData, 60000); // Update every minute

    return () => clearInterval(interval);
  }, []);

  const connectWallet = async () => {
    if (typeof window.ethereum !== 'undefined') {
      try {
        await window.ethereum.request({ method: 'eth_requestAccounts' });
        const provider = new ethers.providers.Web3Provider(window.ethereum);
        const signer = provider.getSigner();
        const address = await signer.getAddress();
        setWalletAddress(address);
        setIsWalletConnected(true);
      } catch (error) {
        console.error("Failed to connect wallet:", error);
      }
    } else {
      alert("Please install MetaMask!");
    }
  };

  const handleClaim = async (e) => {
    e.preventDefault();
    if (!isWalletConnected) {
      alert("Please connect your wallet first!");
      return;
    }
  
    try {
      const provider = new ethers.providers.Web3Provider(window.ethereum);
      const signer = provider.getSigner();
      const edUsdContract = new ethers.Contract(EDUSD_ADDRESS, ['function claim() public'], signer);
      
      const tx = await edUsdContract.claim();
      await tx.wait();
      
      alert(`Successfully claimed 1 edUsd!`);
      
      // Increase circulating supply by 1
      setCirculatingSupply(prevSupply => prevSupply + 1);
    } catch (error) {
      console.error("Error claiming edUsd:", error);
      alert(`Failed to claim edUsd: ${error.message}`);
    }
  };

  return (
    <div className="min-h-screen bg-dark-blue text-broken-white">
      <Head>
        <title>$edUSD - Algorithmic Stablecoin</title>
        <meta name="description" content="$edUSD - The future of educational stablecoins" />
        <link rel="icon" href="/favicon.ico" />
        <style>{`
          .bg-dark-blue { background-color: #1a2b3c; }
          .text-broken-white { color: #e8e6e3; }
          .bg-light-black { background-color: #2c3e50; }
          .claim-button {
            background-image: linear-gradient(to right, #4a90e2, #63b3ed);
            transition: all 0.3s ease;
            font-size: 1.25rem;
            font-weight: bold;
            text-transform: uppercase;
            letter-spacing: 0.1em;
            box-shadow: 0 4px 6px rgba(50, 50, 93, 0.11), 0 1px 3px rgba(0, 0, 0, 0.08);
          }
          .claim-button:hover {
            transform: translateY(-2px);
            box-shadow: 0 7px 14px rgba(50, 50, 93, 0.1), 0 3px 6px rgba(0, 0, 0, 0.08);
          }
        `}</style>
      </Head>

      <header className="bg-light-black p-4 sticky top-0 z-50">
        <div className="container mx-auto flex justify-between items-center">
          <h1 className="text-3xl font-bold">$edUSD</h1>
          <button
            onClick={connectWallet}
            className="bg-broken-white text-dark-blue py-2 px-4 rounded"
          >
            {isWalletConnected ? `${walletAddress.slice(0,6)}...${walletAddress.slice(-4)}` : 'Connect Wallet'}
          </button>
        </div>
      </header>

      <main className="container mx-auto px-4 py-12">
        <section className="text-center mb-20">
          <h2 className="text-5xl font-bold mb-4">
            Welcome to $edUSD
          </h2>
          <p className="text-xl mb-8">The Algorithmic Stablecoin on Edu Chain. Price-stable but supply volatile.</p>
          <div className="text-4xl font-bold">
            Current Price: ${currentPrice.toFixed(2)}
          </div>
        </section>

        <div className="grid md:grid-cols-2 gap-12 mb-20">
          <div className="bg-light-black p-8 rounded-lg">
            <h3 className="text-3xl font-semibold mb-4">What is $edUSD?</h3>
            <p className="text-lg">
            $edUSD is a cutting-edge algorithmic stablecoin designed for educational purposes and real-world applications. 
              Built on Edu Chain, $edUSD leverages advanced algorithms to maintain stability without traditional collateral.
            </p>
          </div>

          <div className="bg-light-black p-8 rounded-lg">
            <h3 className="text-3xl font-semibold mb-4">Key Features</h3>
            <ul className="list-disc list-inside text-lg space-y-2">
              <li>Algorithmic stability mechanism</li>
              <li>Collateral-free design</li>
              <li>Lightning-fast transactions on Edu Chain</li>
              <li>Supply votatile</li>
            </ul>
          </div>
        </div>

        <section className="bg-light-black p-8 rounded-lg mb-20">
          <h3 className="text-3xl font-semibold mb-4">How It Works</h3>
          <p className="text-lg mb-4">
            $edUSD employs a sophisticated algorithmic approach to maintain its peg to the US Dollar:
          </p>
          <ol className="list-decimal list-inside text-lg space-y-3">
            <li>When price exceeds $1, new tokens are minted to increase supply and stabilize price.</li>
            <li>When price falls below $1, tokens are burned to decrease supply and boost price.</li>
            <li>This automated process maintains the $1 peg without traditional collateral.</li>
          </ol>
        </section>

        <div className="grid md:grid-cols-2 gap-12 mb-20">
          <section className="bg-light-black p-8 rounded-lg">
            <h3 className="text-3xl font-semibold mb-6">Claim $edUSD</h3>
            <button 
              onClick={handleClaim}
              className="claim-button w-full text-white py-3 px-6 rounded-md hover:bg-blue-600 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-opacity-50"
            >
              Claim 1 $edUSD
            </button>
          </section>

          <section className="bg-light-black p-8 rounded-lg">
            <h3 className="text-3xl font-semibold mb-6">Supply Info</h3>
            <p className="text-lg mb-2">Total Supply: 1,000,000,000 $edUSD</p>
            <p className="text-lg">Circulating Supply: {circulatingSupply} $edUSD</p>
          </section>
        </div>
      </main>

      <footer className="bg-light-black text-broken-white p-6 mt-12">
        <div className="container mx-auto text-center">
          <p>&copy; 2024 $edUSD by Kaan Kaçar. Revolutionizing Stablecoins.</p>
        </div>
      </footer>
    </div>
  );
}