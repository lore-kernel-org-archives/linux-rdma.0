From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: cx4 sriov problem in stable 4.14.47
Date: Thu, 21 Jun 2018 03:44:35 +0900
Message-ID: <20180620184435.GA32326@kroah.com>
References: <1ae538be-2699-e0cc-adef-2235489472ab@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1ae538be-2699-e0cc-adef-2235489472ab@grimberg.me>
Sender: stable-owner@vger.kernel.org
To: Sagi Grimberg <sagi@grimberg.me>
Cc: "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, Leon Romanovsky <leon@kernel.org>, Saeed Mahameed <saeedm@mellanox.com>, Stable <stable@vger.kernel.org>, Roy Shterman <roys@lightbitslabs.com>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jun 20, 2018 at 01:40:16PM +0300, Sagi Grimberg wrote:
> Hey folks,
> 
> Seems that CX4 (Ethernet) sriov ports probe with link down in the latest
> stable 4.14 kernel. I upgrated firmware but with no luck :(

Did this work on older kernels?  If so, can you use 'git bisect' to
track down the offending commit?

thanks,

greg k-h
