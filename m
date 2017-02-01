From: "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Subject: Querying the GID from a Provider Library
Date: Wed, 1 Feb 2017 12:26:39 +0000
Message-ID: <SN1PR07MB22070E07E3610AFDD7F6DD97F84D0@SN1PR07MB2207.namprd07.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Doug, Yishay,
I need to translate sgid_index to sgid in the library to check for loopback=
.

While invoking ibv_query_gid does the job, it seems to me somewhat
inadequate that a provider library invokes an ibv function and not
an ibv_cmd function. What are your thoughts on this?

I would have invoked the  ibv_cmd_query_gid, but there is no such function
because ibv_query_gid does not require the kernel. However there's an old
*declaration* of the ibv_cmd_query_gid. Perhaps I will define the function
in a similar way to ibv_query_gid?!

Thanks,
Ram


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
