From: Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>
Subject: Re: [PATCH v4 2/4] iw_cxgb4: add queue drain functions
Date: Wed, 9 Mar 2016 14:53:49 +0200
Message-ID: <20160309125349.GA1977@leon.nu>
References: <cover.1455741336.git.swise@chelsio.com>
 <162a5429342dfd5e16881f4360c0ef858fd39cbd.1455741336.git.swise@chelsio.com>
Reply-To: leon-2ukJVAZIZ/Y@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <162a5429342dfd5e16881f4360c0ef858fd39cbd.1455741336.git.swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Feb 17, 2016 at 08:15:42AM -0800, Steve Wise wrote:
> Add completion objects, named sq_drained and rq_drained, to the c4iw_qp
> struct.  The queue-specific completion object is signaled when the last
> CQE is drained from the CQ for that queue.
> 
> Add c4iw_drain_sq() to block until qp->rq_drained is completed.
> 
> Add c4iw_drain_rq() to block until qp->sq_drained is completed.

Hi Steve,
My knowledge is limited in this driver and I have no illusion that
question sounds naive, but why did you add these functions to this
specific driver? Do the other drivers need such update too?

Thanks
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
