From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [ANNOUNCE] Open Fabrics Verbs Working Group (OFVWG) meeting next
 week - 2/7/2017 at 11:00PST
Date: Thu, 2 Feb 2017 23:42:15 -0800
Message-ID: <20170203074215.GA18656@infradead.org>
References: <HE1PR0501MB2812A57B3A481B29DE090E2AB14C0@HE1PR0501MB2812.eurprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <HE1PR0501MB2812A57B3A481B29DE090E2AB14C0-692Kmc8YnlIVrnpjwTCbp8DSnupUy6xnnBOFsp37pqbUKgpGm//BTAC/G2K4zDHf@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "'ofvwg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org'" <ofvwg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Feb 02, 2017 at 10:17:35PM +0000, Liran Liss wrote:
> Hi all,
> 
> Yes, it has been some time since the last meeting...
> We would like to solicit a discussion next week on an API proposal for binding RDMA completion vectors to CPUs.

Please have the discussion on the mailing list.  I have a large patch
series I need to rebase for 4.11 that I will post soon, which wires up
the RDMA drivers to use the new IRQ level MSI-X vector assignment code
and exposes it to RDMA ULPs.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
