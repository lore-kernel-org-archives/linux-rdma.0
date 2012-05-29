From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] {NET,IB}/mlx4: 64 byte CQE/EQE support
Date: Tue, 29 May 2012 17:41:26 +0300
Message-ID: <4FC4E016.4070607@mellanox.com>
References: <1337869844-30259-1-git-send-email-ogerlitz@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1337869844-30259-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tzahi Oved <tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 5/24/2012 5:30 PM, Or Gerlitz wrote:
> The patch makes sure that older guest drivers who follows the
> QUERY_DEV_FUNC command (e.g as done in mlx4_core of Linux 3.3/3.4)
> will notice that they need an update to be able to work with the
> PPF since the returned pf_context_behaviour will not be zero any more.

Roland,

Somethings aren't done right here, when I coded the SRIOV related aspects
of the patch, I missed the fact that the query device capabilities 
command doesn't
have a wrapper...

Jack is now fixing that with the SRIOV IB patches he's working on,
so please hold off with accepting this patch. I would still love to get 
feedback on
the design re user space, etc compatibility and the patch in general.

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
