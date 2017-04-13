From: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH v2 0/4] arbitrary sg lists support
Date: Thu, 13 Apr 2017 16:31:20 +0000
Message-ID: <1492101079.5176.9.camel@sandisk.com>
References: <1492098977-5231-1-git-send-email-maxg@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1492098977-5231-1-git-send-email-maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Content-Language: en-US
Content-ID: <C04CB30BCEFB5F4089ABC92B5049263F-+cFlbfsKLD6cE4WynfumptQqCkab/8FMAL8bYrjMMd8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "hch-jcswGhMUV9g@public.gmane.org" <hch-jcswGhMUV9g@public.gmane.org>, "maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "keith.busch-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <keith.busch-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, 2017-04-13 at 18:56 +0300, Max Gurtovoy wrote:
> This patch adds an arbitrary sg list support to NVMEoF host for
> capable devices (such as RDMA CX4/CX5 HCAs).
> During the review we decided to add an helper function to ib_core
> that will be used by ULPs in order to avoid code duplication.

Hello Max,

A question that is not related to the ULP drivers touched by this patch ser=
ies:
some time ago registration of sg-lists with gaps was disabled in the SRP
initiator because arbitrary sg-lists triggered CQE dumps in combination wit=
h the
mlx5 driver. Does this mean that this issue has been resolved? If so, what =
mlx5
driver and/or firmware version are needed to reenable arbitrary sg-list sup=
port
in the SRP initiator?

Thanks,

Bart.=
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
