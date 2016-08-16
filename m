From: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Subject: RE: [PATCH v2 02/15] IB/pvrdma: Add device command support
Date: Tue, 16 Aug 2016 16:51:19 +0000
Message-ID: <BLUPR0501MB836A9EB3D27557F39350818C5130@BLUPR0501MB836.namprd05.prod.outlook.com>
References: <1468352205-9137-1-git-send-email-aditr@vmware.com>
 <1468352205-9137-3-git-send-email-aditr@vmware.com>
 <20160718124652.GE6165@yuval-lap.uk.oracle.com>
 <BLUPR0501MB8363954E94FE9D268E66CB7C5000@BLUPR0501MB836.namprd05.prod.outlook.com>
 <20160729123711.GU4628@leon.nu>
 <BLUPR0501MB8364D3CE8FF7DE654D1E045C5010@BLUPR0501MB836.namprd05.prod.outlook.com>
 <20160731061547.GV4628@leon.nu> <20160814112536.GA3404@yuval-lap>
 <20160814172344.GA5548@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160814172344.GA5548-2ukJVAZIZ/Y@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, pv-drivers <pv-drivers-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, "Jorgen S. Hansen" <jhansen-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, Aditya Sarwade <asarwade-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, George Zhang <georgezhang-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, Bryan Tan <bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, Aug 14, 2016 at 17:24:46 +0000, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> w=
rote:
> On Sun, Aug 14, 2016 at 02:25:36PM +0300, Yuval Shaia wrote:
> > On Sun, Jul 31, 2016 at 09:15:47AM +0300, Leon Romanovsky wrote:
> > > On Fri, Jul 29, 2016 at 09:31:16PM +0000, Adit Ranadive wrote:
> > > > On Fri, 29 Jul 2016 12:37:29 +0000, Leon Romanovsky <leon-DgEjT+Ai2yhQFI55V6+gNQ@public.gmane.org=
g> wrote:
> > > > > On Thu, Jul 28, 2016 at 10:51:39PM +0000, Adit Ranadive wrote:
> > > > > > On Mon, 18 Jul 2016 15:46:53 +0300 Yuval Shaia <yuval.shaia@ora=
cle.com> wrote:
> > > > > > > On Tue, Jul 12, 2016 at 12:36:32PM -0700, Adit Ranadive wrote=
:
> > > > > > > > This patch enables posting Verb requests and receiving resp=
onses to/from
> > > > > > > > the backend PVRDMA emulation layer.
> > > > > > > >
> > > > > >
> > > > > > ...
> > > > > >
> > > > > > > > +int
> > > > > > > > +pvrdma_cmd_post(struct pvrdma_dev *dev, union pvrdma_cmd_r=
eq *req,
> > > > > > > > +		bool expect_resp, union pvrdma_cmd_resp *resp)
> > > > > > > > +{
> > > > > > > > +	int err;
> > > > > > > > +
> > > > > > > > +	dev_dbg(&dev->pdev->dev, "post request to device\n");
> > > > > > > > +
> > > > > > > > +	/* Serializiation */
> > > > > > > > +	down(&dev->cmd_sema);
> > > > > > > > +
> > > > > > > > +	spin_lock(&dev->cmd_lock);
> > > > > > > > +	memcpy(dev->cmd_slot, req, sizeof(*req));
> > > > > > >
> > > > > > > Just to protect against memory corruption suggesting to do:
> > > > > > > 	memcpy(dev->cmd_slot, req, min(PAGE_SIZE, sizeof(*req)));
> > > > > > >
> > > > > >
> > > > > > Done.
> > > > >
> > > > > Hi Adit,
> > > > > I didn't check how "dev->cmd_slot" was declared and if it is equa=
l to
> > > > > req in size. Additionally I didn't check if memcpy has any size
> > > > > limitations, but wanted to warn you that implementation of this
> > > > > suggestion as is will leave your system in much worse situation o=
f
> > > > > partially copied data.
> > > > >
> > > > > if you really want to check sizes, please do it with BUILD_ON com=
pilation
> > > > > macro. I have serious doubts if you need it.
> > > > >
> > > > > Thanks
> > > >
> > > > Hi Leon,
> > > >
> > > > Thanks for taking a look!
> > > > I think this is okay to do was that we allocate a page for cmd_slot=
 anyways
> > > > and the size of req will always be smaller than PAGE_SIZE. If the r=
equest is
> > > > malformed, our virtual hardware should throw an error for it.
> > > > I dont think we would run into partially copied data.
> > > >
> > > > Having said that, I dont see a necessary advantage of using min her=
e so am
> > > > willing to drop it if you feel strongly about it.
> > > >
> > > > Can you clarify what you mean by memcpy size limitations?
> > >
> > > I didn't have time to look after reasons for Yuval's comment about
> > > min(..), so I assumed that one of the possibilities will be limitatio=
n
> > > of memcpy which I'm not aware.
> >
> > I understand that it is not such realistic that one of the structures i=
n
> > union pvrdma_cmd_req will be more then PAGE_SIZE but any other alternat=
ive
> > to protect from such case?
>=20
> BUILD_BUG_ON(...) is a perfect way to achieve it.

Thanks for your comments, Leon and Yuval! I will add that in v4 of the patc=
h series.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
