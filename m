From: David Miller <davem@davemloft.net>
Subject: Re: [BUG] Bad page map in process ibv_devinfo
Date: Thu, 17 Nov 2011 21:29:36 -0500 (EST)
Message-ID: <20111117.212936.140468226440693253.davem@davemloft.net>
References: <CAL1RGDV_AwOOnLvWJKGqBTaptetfVN_gXNG=PcaFUXYSXrQ5AA@mail.gmail.com>
	<20111117.210316.83327515715765011.davem@davemloft.net>
	<CAL1RGDVRnBQ1aaJn-RhiWpcdW89VBa+QgH8Z8YPJOt-7Wfmbmg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <sparclinux-owner@vger.kernel.org>
In-Reply-To: <CAL1RGDVRnBQ1aaJn-RhiWpcdW89VBa+QgH8Z8YPJOt-7Wfmbmg@mail.gmail.com>
Sender: sparclinux-owner@vger.kernel.org
To: roland@purestorage.com
Cc: linux@razik.name, sparclinux@vger.kernel.org, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: Roland Dreier <roland@purestorage.com>
Date: Thu, 17 Nov 2011 18:17:08 -0800

> Anyway definitely makes sense as something to check.

Another difference is remap_pfn_range() uses pte_mkspecial().
