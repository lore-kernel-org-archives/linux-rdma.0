From: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: Issue with IB/ipoib: Remove device when one port fails to init
Date: Wed, 29 Nov 2017 08:23:32 +0200
Message-ID: <20171129062331.GA2826@yuvallap>
References: <20171108140645.GA5683@yuvallap>
 <03848fab-3c72-681e-e32f-14560a84f59a@mellanox.com>
 <VI1PR0502MB36143F956ACD3518BC13C9CFB6560@VI1PR0502MB3614.eurprd05.prod.outlook.com>
 <20171108161356.GC6935@yuvallap>
 <20171109113923.GB2949@yuvallap>
 <VI1PR0502MB3614A65D0F63E0CDBBD00EF6B6570@VI1PR0502MB3614.eurprd05.prod.outlook.com>
 <20171109172112.GA3726@yuvallap>
 <AM4PR0501MB19723DE7524AA90DC8A2C111C33A0@AM4PR0501MB1972.eurprd05.prod.outlook.com>
 <20171128190345.GB2640@yuvallap>
 <20171128210012.GE21325@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171128210012.GE21325-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: Alex Vesker <valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Alaa Hleihel <alaa-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Nov 28, 2017 at 02:00:12PM -0700, Jason Gunthorpe wrote:
> On Tue, Nov 28, 2017 at 09:03:46PM +0200, Yuval Shaia wrote:
> 
> > I agree that patch as it is now does not really handle the case where one
> > port fails so it needs to be fixed.
> > 
> > The thing is that from your perspective the idea itself is wrong, i.e. if
> > one (of for example two ports) fails the driver needs to continue and serve
> > the other port and just print error message.
> 
> On this point, I think if ports are completely independent at the ipoib
> layer then they should not become linked during the add process.
> 
> ie if a port is working and a second port fails then it should not
> kill the first port.
> 
> However, it is unfortunate we have no recovery from this case at all.
> 
> Alex V: However, why is the current behavior a problem? Is this
> because of a dual port card with IB and ROCE concurrently? And the
> add 'fails' the ROCE port even though it isn't even really a failure?
> We certainly shouldn't print in that case..

Per my understanding - no.
Alex is referring to a system where a two ports card is running RocE on
both, Alex, please correct me if i'm wrong.

The current state of ipoib_add_one does not kill the working port on such
case, it just print an error message (not a warning).

Please review the patch "IB/ipoib: Warn when one port fails to initialize"
which fixes it by removing the error message and the call to
ipoib_remove_one and adds missing warning message to ipoib_add_port.

> 
> Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
