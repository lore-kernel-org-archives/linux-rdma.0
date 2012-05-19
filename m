From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH for-next 5/6] net/mlx4: Adjust initial value of vl_cap in mlx4_SET_PORT
Date: Fri, 18 May 2012 17:40:41 -0700
Message-ID: <CAL1RGDUjNrRnU2_cfbdJd790K9oLD+rRFQDOyR6eX-3R1tWbQA@mail.gmail.com>
References: <1336681689-16668-1-git-send-email-ogerlitz@mellanox.com> <1336681689-16668-6-git-send-email-ogerlitz@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1336681689-16668-6-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Aviad Yehezkel <aviadye-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> +#define CX3_PPF_DEV_ID 0x1003
> +
> +static int vl_cap_start(struct mlx4_dev *dev)
> +{
> + =A0 =A0 =A0 /* for non CX3 devices, start with 4 VLs to avoid error=
s in syslog */
> + =A0 =A0 =A0 if (dev->pdev->device !=3D CX3_PPF_DEV_ID)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 4;
> + =A0 =A0 =A0 return 8;
> +}

This really doesn't look maintainable as different devices with
different limits come along.

How ugly is it to pass some sort of "no warn" flag down into
the command to suppress the messages?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
