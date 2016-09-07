From: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3 12/15] IB/pvrdma: Add the main driver module for PVRDMA
Date: Wed, 7 Sep 2016 20:19:39 +0000
Message-ID: <BLUPR0501MB836DE703D4FAE03EB9873D7C5F80@BLUPR0501MB836.namprd05.prod.outlook.com>
References: <1470266864-16888-1-git-send-email-aditr@vmware.com>
 <1470266864-16888-13-git-send-email-aditr@vmware.com>
 <20160901165404.GA3429@yuval-lap.mynet>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160901165404.GA3429-Hxa29pjIrESt9MVyvc/JHg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, pv-drivers <pv-drivers-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, "Jorgen S. Hansen" <jhansen-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, Aditya Sarwade <asarwade-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, George Zhang <georgezhang-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, Bryan Tan <bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On  Thu, Sep 01, 2016 at 09:54:17 -0700, Yuval Shaia wrote:=20
> On Wed, Aug 03, 2016 at 04:27:41PM -0700, Adit Ranadive wrote:
> +
> > +	/* Activate pvrdma device */
> > +	pvrdma_write_reg(dev, PVRDMA_REG_CTL,
> PVRDMA_DEVICE_CTL_ACTIVATE);
> > +
> > +	/* Make sure the write is complete before reading status. */
> > +	mb();
> > +
> > +	/* Check if device was successfully activated */
> > +	ret =3D pvrdma_read_reg(dev, PVRDMA_REG_ERR);
> > +	if (ret !=3D 0) {
> > +		dev_err(&pdev->dev, "failed to activate device\n");
> > +		ret =3D -EINVAL;
> > +		goto err_disable_intr;
> > +	}
>=20
> What if it will take the device to activate longer than the time between
> write to PVRDMA_DEVICE_CTL_ACTIVATE and read from
> PVRDMA_REG_ERR?

I don't think that would happen here since the device executes the command
pretty much synchronously.=20
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
