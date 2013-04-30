From: Wendy Cheng <s.wendy.cheng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: NFS over RDMA benchmark
Date: Tue, 30 Apr 2013 09:24:10 -0700
Message-ID: <CABgxfbFn=OJkYdCd3CFCOWQ04EN=76LgC=O-uG4RSL3btneosw@mail.gmail.com>
References: <0EE9A1CDC8D6434DB00095CD7DB873462CF96C65@MTLDAG01.mtl.com>
	<CABgxfbF7c9ktSoMSPV21JU76V5J4iwbJQ257S91Y3z36WJbJVA@mail.gmail.com>
	<62745258-4F3B-4C05-BFFD-03EA604576E4@ornl.gov>
	<CABgxfbGxhnKj2n0Z-w87rZ6fwCssO31G009gwej957gv1p8PQQ@mail.gmail.com>
	<0EE9A1CDC8D6434DB00095CD7DB873462CF9715B@MTLDAG01.mtl.com>
	<20130423210607.GJ3676@fieldses.org>
	<0EE9A1CDC8D6434DB00095CD7DB873462CF988C9@MTLDAG01.mtl.com>
	<20130424150540.GB20275@fieldses.org>
	<20130424152631.GC20275@fieldses.org>
	<0EE9A1CDC8D6434DB00095CD7DB873462CF9A820@MTLDAG01.mtl.com>
	<20130428144248.GA2037@fieldses.org>
	<0EE9A1CDC8D6434DB00095CD7DB873462CF9C90C@MTLDAG01.mtl.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <0EE9A1CDC8D6434DB00095CD7DB873462CF9C90C-fViJhHBwANKuSA5JZHE7gA@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yan Burman <yanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>, "Atchley, Scott" <atchleyes-1Heg1YXhbW8@public.gmane.org>, Tom Tucker <tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Apr 29, 2013 at 10:09 PM, Yan Burman <yanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
>
> I finally got up to 4.1GB/sec bandwidth with RDMA (ipoib-CM bandwidth is also way higher now).
> For some reason when I had intel IOMMU enabled, the performance dropped significantly.
> I now get up to ~95K IOPS and 4.1GB/sec bandwidth.
> Now I will take care of the issue that I am running only at 40Gbit/s instead of 56Gbit/s, but that is another unrelated problem (I suspect I have a cable issue).
>
> This is still strange, since ib_send_bw with intel iommu enabled did get up to 4.5GB/sec, so why did intel iommu affect only nfs code?
>

That's very exciting ! The sad part is that IOMMU has to be turned off.

I think ib_send_bw uses a single buffer so the DMA mapping search
overhead is not an issue.

-- Wendy
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
