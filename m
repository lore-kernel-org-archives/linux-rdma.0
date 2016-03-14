From: Matthew Wilcox <willy-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH RFC 1/1] Add support for ZONE_DEVICE IO memory with
 struct pages.
Date: Mon, 14 Mar 2016 17:23:44 -0400
Message-ID: <20160314212344.GC23727@linux.intel.com>
References: <1457979277-26791-1-git-send-email-stephen.bates@pmcs.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1457979277-26791-1-git-send-email-stephen.bates-PwyqCcigF0Q@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Stephen Bates <stephen.bates-PwyqCcigF0Q@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, javier-rmLALz0KWFtWk0Htik3J/w@public.gmane.org, sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Mar 14, 2016 at 12:14:37PM -0600, Stephen Bates wrote:
> 3. Coherency Issues. When IOMEM is written from both the CPU and a PCIe
> peer there is potential for coherency issues and for writes to occur out
> of order. This is something that users of this feature need to be
> cognizant of and may necessitate the use of CONFIG_EXPERT. Though really,
> this isn't much different than the existing situation with RDMA: if
> userspace sets up an MR for remote use, they need to be careful about
> using that memory region themselves.

There's more to the coherency problem than this.  As I understand it, on
x86, memory in a PCI BAR does not participate in the coherency protocol.
So you can get a situation where CPU A stores 4 bytes to offset 8 in a
cacheline, then CPU B stores 4 bytes to offset 16 in the same cacheline,
and CPU A's write mysteriously goes missing.

I may have misunderstood the exact details when this was explained to me a
few years ago, but the details were horrible enough to run away screaming.
Pretending PCI BARs are real memory?  Just Say No.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
