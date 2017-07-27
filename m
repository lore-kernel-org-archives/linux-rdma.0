From: "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Subject: RE: [PATCH rdma-core 0/5] Common systemd/udev based boot support
Date: Thu, 27 Jul 2017 07:47:03 +0000
Message-ID: <BN3PR07MB257807A6AE85B9B5575AAD7AF8BE0@BN3PR07MB2578.namprd07.prod.outlook.com>
References: <1500929067-1583-1-git-send-email-jgunthorpe@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1500929067-1583-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Leon Romanovsky <notifications-9UaJU3cA/F/QT0dZR+AlfA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Jason,

> I do not have nearly enough hardware to exhaustively test this, I have ch=
ecked
> that the basic elements are working, but there is lots of room for little
> errors, particularly in module names and udev matching. It would be great=
 of
> someone could try this on iwarp hardware and confirm all the autoloading =
works
> as expected.
>=20
> As should the active roce vendors. I expect that all roce hardware will
> autoload the RDMA modules with this approach.

It works for qedr.

I have followed Steve's steps and built the rpms on Red Hat 7.3 from your r=
epo/systemd.
I've removed all the previous libraries and 98-rdma.rules and then installe=
d the newly built rpms=20
After that I rebooted and qedr was loaded.
I didn't have to configure the interfaces as Steve did (ifconfig <device> u=
p).

I've notice that 98-rdma.rules got recreated, but the new file doesn't cont=
ain any qed entry.
Why is it recreated? If it is in use, why isn't qed listed?

> +# Hardware that supports iWarp
> +DRIVERS=3D=3D"cxgb3", ENV{ID_RDMA_IWARP}=3D"1"
> +DRIVERS=3D=3D"cxgb4", ENV{ID_RDMA_IWARP}=3D"1"
> +
> +# Hardware that supports RoCE
> +DRIVERS=3D=3D"be2net", ENV{ID_RDMA_ROCE}=3D"1"
> +DRIVERS=3D=3D"bnxt_en", ENV{ID_RDMA_ROCE}=3D"1"
> +DRIVERS=3D=3D"hns", ENV{ID_RDMA_ROCE}=3D"1"
> +DRIVERS=3D=3D"i40e", ENV{ID_RDMA_ROCE}=3D"1"
> +DRIVERS=3D=3D"mlx4_core", ENV{ID_RDMA_ROCE}=3D"1"
> +DRIVERS=3D=3D"mlx5_core", ENV{ID_RDMA_ROCE}=3D"1"
> +DRIVERS=3D=3D"qede", ENV{ID_RDMA_ROCE}=3D"1"

We've recently sent iWARP patches this means qede will be used by either Ro=
CE or iWARP.
In any case the RDMA driver is the same - qedr.

Can you explain what effect does this ENV property has on actual operation?
How do you think it should look in the light of the upcoming patch?

Thanks for coding this,
Ram

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
