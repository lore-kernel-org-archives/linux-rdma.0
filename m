From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: Need to set if_index in ib_init_ah_from_wc() ?
Date: Sun, 29 Oct 2017 12:26:24 -0600
Message-ID: <20171029182624.GA7052@ziepe.ca>
References: <CAL1RGDW6iHo2UYKbcJmcG=wCq63jvZB7nvOD=BJZwASSzc7Zhw@mail.gmail.com>
 <20170130195412.GE24466@obsidianresearch.com>
 <VI1PR0502MB30086B735FD4B5948B521673D14D0@VI1PR0502MB3008.eurprd05.prod.outlook.com>
 <CANjDDBhJK=s28zrdCASUVSSeem=NVRWwsHT=jWS2N4jGh2Uvfw@mail.gmail.com>
 <VI1PR0502MB300803053059AA7CC0E6DA7DD1420@VI1PR0502MB3008.eurprd05.prod.outlook.com>
 <VI1PR0502MB30087224F41436F787C4997FD1460@VI1PR0502MB3008.eurprd05.prod.outlook.com>
 <20171023173946.GP2106@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171023173946.GP2106-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Somnath Kotur <somnath.kotur-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Oct 23, 2017 at 08:39:46PM +0300, Leon Romanovsky wrote:

> I would like to have proper deadline here, from one side, I don't want
> to wait for Broadcom's fix forever, but from another, I don't want to
> forward ANY patch which breaks other vendors.

I've had the guess that each driver will need to provide a WC to gid
table entry conversion function..

Ideal hardware driver will report the gid table index in their
internal WC. Other hardware like mlx wil have to parse the WC and the
GRH headers and so forth to figure out the gid table index.

The gid table index is security sensitive, so it *MUST* be determined
exactly and correctly.

But we need to understand what the other rocee drivers have done in
this area..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
