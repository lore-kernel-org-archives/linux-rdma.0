From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH RFC v2 02/10] IB/core: Introduce Signature Verbs API
Date: Fri, 01 Nov 2013 15:23:35 -0700
Message-ID: <527429E7.7010705@acm.org>
References: <1383222255-22699-1-git-send-email-sagig@mellanox.com> <1383222255-22699-3-git-send-email-sagig@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1383222255-22699-3-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 31/10/2013 5:24, Sagi Grimberg wrote:
> + * 		@type3_inc_reftag: T10-DIF type 3 does not state
> + *			about the reference tag, it is the user
> + *			choice to increment it or not.

Can you explain this further ? Does this mean that the HCA can check 
whether the reference tags are increasing when receiving data for TYPE 3 
protection mode ? My understanding of SPC-4 is that the application is 
free to use the reference tag in any way when using TYPE 3 protection 
and hence that the HCA must not check whether the reference tag is 
increasing for TYPE 3 protection. See e.g. sd_dif_type3_get_tag() in 
drivers/scsi/sd_dif.c.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
