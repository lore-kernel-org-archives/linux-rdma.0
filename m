From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-core 6/7] ibverbs: Update man pages to include cvlan
 offloads options
Date: Tue, 14 Mar 2017 09:48:49 -0600
Message-ID: <20170314154849.GC3244@obsidianresearch.com>
References: <1489490143-29018-1-git-send-email-yishaih@mellanox.com>
 <1489490143-29018-7-git-send-email-yishaih@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1489490143-29018-7-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Mar 14, 2017 at 01:15:42PM +0200, Yishai Hadas wrote:
> From: Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> 
> Provide information about the cvlan stripping offload for
> - ibv_create_wq
> - ibv_modify_wq
> - ibv_create_cq_ex
> - ibv_query_device_ex

I continue to be annoyed that these patches are extending the 'common'
API without providing enough descriptive information to understand
exactly what these new options are supposed to do and how to implement
them.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
