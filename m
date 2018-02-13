From: "Llolsten Kaonga" <llk-rzwDkyJvnYokmLvzuZlaBw@public.gmane.org>
Subject: RE: [PATCH rdma-core] vmw_pvrdma: Fix SRQN returned to library
Date: Tue, 13 Feb 2018 09:10:09 -0500
Message-ID: <001501d3a4d4$5bb866f0$132934d0$@soft-forge.com>
References: <1518460956-4629-1-git-send-email-aditr@vmware.com> <de50c35a-731d-bfb6-efe9-7f2ad83ea7b3@suse.de>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <de50c35a-731d-bfb6-efe9-7f2ad83ea7b3-l3A5Bk7waGM@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Nicolas Morey-Chaisemartin' <NMoreyChaisemartin-l3A5Bk7waGM@public.gmane.org>, 'Adit Ranadive' <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, 'Aditya Sarwade' <asarwade-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, stable-Xl5UnYtxxKxKUA01WzcqbQ@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

OFED 4.8.2 rc1 was just released on 02/09/2018.

The Openfabrics EWG chair thinks maybe 2-4 weeks out for OFED 4.8.2.

Cheers.
--
Llolsten

-----Original Message-----
From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Nicolas Morey-Chaisemartin
Sent: Tuesday, February 13, 2018 7:24 AM
To: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>; dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org; jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org; leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Aditya Sarwade <asarwade-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>; stable-Xl5UnYtxxKxKUA01WzcqbQ@public.gmane.org
Subject: Re: [PATCH rdma-core] vmw_pvrdma: Fix SRQN returned to library



Le 12/02/2018 à 19:42, Adit Ranadive a écrit :
> From: Aditya Sarwade <asarwade-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
>
> Here's a fix for the vmw_pvrdma library. It needs to go into the 
> stable branch for 16.0 as well since we can then add it to OFED-4.8-2.
>
> The PR is here:
> https://github.com/linux-rdma/rdma-core/pull/291
>
> Thanks,
> Adit
> ---
>

Submitted to stable-v16.
Do you know when OFED 4.8-2 is going out ? Is a new v16.3 release needed right now ?

Nicolas
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org More majordomo info at  http://vger.kernel.org/majordomo-info.html


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
