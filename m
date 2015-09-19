From: "santosh.shilimkar-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org" <santosh.shilimkar-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v1 00/24] New fast registration API
Date: Sat, 19 Sep 2015 19:20:53 -0400
Message-ID: <55FDEDD5.1090105@oracle.com>
References: <1442482947-27785-1-git-send-email-sagig@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1442482947-27785-1-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 9/17/15 5:42 AM, Sagi Grimberg wrote:
> Hi all,
>
> As discussed on the linux-rdma list, there is plenty of room for
> improvement in our memory registration APIs. We keep finding
> ULPs that are duplicating code, sometimes use wrong strategies
> and mis-use our current API.
>
> As a first step, this patch set replaces the fast registration API
> to accept a kernel common struct scatterlist and takes care of
> the page vector construction in the core layer with hooks for the
> drivers HW specific assignments. This allows to remove a common
> code duplication as it was done in each and every ULP driver.
>
> The changes from v0 (WIP) are:
> - Rebased on top of 4.3-rc1 + Christoph's ib_send_wr conversion patches
>
> - Allow the ULP to pass page_size argument to ib_map_mr_sg in order
>    to have it work better in some specific workloads. This suggestion
>    came from Bart Van Assache which pointed out that some applications
>    might use page sizes significantly smaller than the system PAGE_SIZE
>    of specific architectures
>
> - Fixed some logical bugs in ib_sg_to_pages
>
> - Added a set_page function pointer for drivers to pass to ib_sg_to_pages
>    so some drivers (e.g mlx4, mlx5, nes) can avoid keeping a second page
>    vector and/or re-iterate on the page vector in order to perform HW specific
>    assignments (big/little endian conversion, extra flags)
>
> - Converted SRP initiator and RDS iwarp ULPs to the new API
>
> - Removed fast registration code from hfi1 driver (as it isn't supported
>    anyway). I assume that the correct place to get the support back would
>    be in a shared SW library (hfi1, qib, rxe).
>
> - Updated the change logs
>
> So far my tests covered:
> - ULPs:
> 	* iser initiator
> 	* iser target
> 	* xprtrdma
> 	* svcrdma
> - Drivers:
> 	* mlx4
> 	* mlx5
> 	* Steve Wise was kind enough to run NFS client/server over cxgb4 and I
> 	  have yet to receive any negative feedback from him.
>
> I don't have access to other HW devices (qib, nes) nor iwarp devices so RDS is
> compile tested only.
>
Nice to see this consolidaton happening. I too don't have access to
iWARP hardware for RDS test but will use this series and convert our WIP 
IB fastreg code and see how it goes.

Regards,
Santosh


--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
