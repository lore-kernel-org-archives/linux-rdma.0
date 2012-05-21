From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH for-next 5/6] net/mlx4: Adjust initial value of vl_cap in mlx4_SET_PORT
Date: Mon, 21 May 2012 09:14:25 -0700
Message-ID: <CAL1RGDX7dBzKZv4nC0jKyoYDuQh6x2Yn8RSuyZsHs_=-YvczKg@mail.gmail.com>
References: <1336681689-16668-1-git-send-email-ogerlitz@mellanox.com>
 <1336681689-16668-6-git-send-email-ogerlitz@mellanox.com> <CAL1RGDUjNrRnU2_cfbdJd790K9oLD+rRFQDOyR6eX-3R1tWbQA@mail.gmail.com>
 <4FB8D3C0.7040603@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4FB8D3C0.7040603-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Aviad Yehezkel <aviadye-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> =A0BTW I noticed
> that today there IS some CX3 special code in mlx4_core/main.c
>
>> 282- =A0 =A0/* Sense port always allowed on supported devices for Co=
nnectX1
>> and 2 */
>> 283: =A0 =A0if (dev->pdev->device !=3D 0x1003)
>> 284- =A0 =A0 =A0 =A0 =A0 =A0dev->caps.flags |=3D MLX4_DEV_CAP_FLAG_S=
ENSE_SUPPORT;

Yeah, I think this has similar maintainability problems.  Looks like it
went through the net tree ... and davem doesn't alway review driver
changes in depth.

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
