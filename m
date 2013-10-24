From: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH for-next 7/9] mlx5: Support arbitrary page size to
 firmware
Date: Thu, 24 Oct 2013 11:06:12 +0300
Message-ID: <20131024080612.GA18644@mtldesk30>
References: <1382511201-7061-1-git-send-email-eli@mellanox.com>
 <1382511201-7061-8-git-send-email-eli@mellanox.com>
 <CAG4TOxPfHR8h22E5reYSghNszzvHCUfQLMOH6mphNTc+QWc16Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAG4TOxPfHR8h22E5reYSghNszzvHCUfQLMOH6mphNTc+QWc16Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, yevgenyp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Oct 24, 2013 at 12:57:47AM -0700, Roland Dreier wrote:
> On Tue, Oct 22, 2013 at 11:53 PM, Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:
> > This patch also fixes several places that referred to PAGE_SHIFT instead of
> > explicit 12 which is the inherent page shift on Connect-IB.
> 
> Patch looks fine but maybe we should have a follow-up that changes
> this magic constant of 12 to something like MLX5_ADAPTER_PAGE_SHIFT
> (defined to 12 in a header somewhere)?
> 
Yes it makes sense.
I am going to send a few more patches and will include one that fixes
the page shift thing.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
