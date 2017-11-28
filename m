From: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: Issue with IB/ipoib: Remove device when one port fails to init
Date: Tue, 28 Nov 2017 21:03:46 +0200
Message-ID: <20171128190345.GB2640@yuvallap>
References: <AM4PR0501MB1972F0E7AC9B7559563CAEC0C3560@AM4PR0501MB1972.eurprd05.prod.outlook.com>
 <20171108140645.GA5683@yuvallap>
 <03848fab-3c72-681e-e32f-14560a84f59a@mellanox.com>
 <VI1PR0502MB36143F956ACD3518BC13C9CFB6560@VI1PR0502MB3614.eurprd05.prod.outlook.com>
 <20171108161356.GC6935@yuvallap>
 <20171109113923.GB2949@yuvallap>
 <VI1PR0502MB3614A65D0F63E0CDBBD00EF6B6570@VI1PR0502MB3614.eurprd05.prod.outlook.com>
 <20171109172112.GA3726@yuvallap>
 <AM4PR0501MB19723DE7524AA90DC8A2C111C33A0@AM4PR0501MB1972.eurprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <AM4PR0501MB19723DE7524AA90DC8A2C111C33A0-dp/nxUn679iNboccmCdZNcDSnupUy6xnnBOFsp37pqbUKgpGm//BTAC/G2K4zDHf@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Vesker <valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Alaa Hleihel <alaa-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

+linux-rdma

Hi Alex,
I agree that patch as it is now does not really handle the case where one
port fails so it needs to be fixed.

The thing is that from your perspective the idea itself is wrong, i.e. if
one (of for example two ports) fails the driver needs to continue and serve
the other port and just print error message.

This is not me to decide, adding linux-rdma to decide. 

As soon as i will get ack/nak i will post a Fixup patch.

Thanks,
Yuval

On Tue, Nov 28, 2017 at 11:35:53AM +0000, Alex Vesker wrote:
> Yuval?
> 
> -----Original Message-----
> From: Alex Vesker 
> Sent: Thursday, November 16, 2017 9:38 AM
> To: 'Yuval Shaia' <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>; Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Cc: Alaa Hleihel <alaa-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>; Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>; Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Subject: RE: Issue with IB/ipoib: Remove device when one port fails to init
> 
> Hi Yuva,l I think that if add_port fails we should give a print.
> The add one function is void so we are not hiding an error here in case one port fails.
> Remove one goes over dev_list (we add only if add_port succeed) so we also don't need to worry about it double freeing or similar.
> 
> If you are able to add only one of two port I don't see a reason to fail add_one and remove the good port, From what I see current code can handle it without errors, and this is more robust than failing all.
> 
> The fix you can add is a print incase add_port fails. Tell me what you think.
> Please provide a fix since many teams are complaining about current error in case port is ETH ROCE.
> 
> 
> -----Original Message-----
> From: Yuval Shaia [mailto:yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org]
> Sent: Thursday, November 09, 2017 7:21 PM
> To: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Cc: Alex Vesker <valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>; Alaa Hleihel <alaa-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>; Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>; Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Subject: Re: Issue with IB/ipoib: Remove device when one port fails to init
> 
> Right, my mistake.
> But still my question is in case that port 1 succeeded and port 2 not we want the driver to stay "up" and serve only port 1 or do cleanup and print error message?
> 
> Yuval
> 
> On Thu, Nov 09, 2017 at 12:41:52PM +0000, Erez Shitrit wrote:
> > Hi
> > 
> > If ipoib_add_port function fails it cleans all what it allocated, so probably in this case we should be good.
> > If you see otherwise and ipoib_add_port has some left over we should fix that instead.
> > 
> > Erez
> > 
> > 
> > -----Original Message-----
> > From: Yuval Shaia [mailto:yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org]
> > Sent: Thursday, November 09, 2017 1:39 PM
> > To: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > Cc: Alex Vesker <valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>; Alaa Hleihel 
> > <alaa-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>; Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>; Leon Romanovsky 
> > <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > Subject: Re: Issue with IB/ipoib: Remove device when one port fails to 
> > init
> > 
> > On Wed, Nov 08, 2017 at 06:13:56PM +0200, Yuval Shaia wrote:
> > > On Wed, Nov 08, 2017 at 03:32:14PM +0000, Erez Shitrit wrote:
> > > > I think that the fix is no longer relevant here, it was relevant in previous versions of ipoib where the ports shared resources, and when one of them is in bad condition it is better to get out.
> > > 
> > > Erez, it is not only a matter of HW resources, just consider the 
> > > case where ib_query_port failed for second port, we had allocated 
> > > memory for priv, don't we need to free it?
> > 
> > So Erez, what do you think?
> > Put some pressure on you since if it is needed then i'd like to post quick fix patch.
> > 
> > > 
> > > Yuval
> > > 
> > > > Currently each port for itself, so probably no need to run in that case.
> > > > (Or at least this is what need to check in order to understand if 
> > > > it still relevant.)
> > > > 
> > > > Thanks, Erez
> > > > 
> > > > -----Original Message-----
> > > > From: Alex Vesker
> > > > Sent: Wednesday, November 08, 2017 5:13 PM
> > > > To: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> > > > Cc: Alaa Hleihel <alaa-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>; Majd Dibbiny 
> > > > <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>; Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>; Leon 
> > > > Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > > > Subject: Re: Issue with IB/ipoib: Remove device when one port 
> > > > fails to init
> > > > 
> > > > 
> > > > 
> > > > On 11/8/2017 4:06 PM, Yuval Shaia wrote:
> > > > > On Wed, Nov 08, 2017 at 11:33:02AM +0000, Alex Vesker wrote:
> > > > >> Hi Yuval,
> > > > >> We are having unnecessary prints coming from a patch you sent.
> > > > >> This happens in case we are using only ETH devices, count==0, the pr_err is printed with a failure.
> > > > > Why IPoIB driver is used with ETH device?
> > > > When using ROCE (RDMA over ETH)
> > > > >> Also in case ipoib_remove_one is called with an empty list it simply releases it, same as in the original code.
> > > > >> Can you explain the reason for that change?
> > > > > Idea is to undo all the things that were done in case where one 
> > > > > port was fail to initialize.
> > > > >
> > > > > Consider the (weird) case where port 1 succeeds but port 2 fails. 
> > > > > Do we want to leave the system half baked?
> > > > I am not sure here, but it is probably better to be more robust, if we are able to have only one port for some reason I don't see a reason to unregister it, unless it might cause a problem later on.
> > > > Erez what do you think?
> > > > >
> > > > > Looking at the implementation i found it wrong by not doing what 
> > > > > title says.
> > > > >
> > > > > It should be something like
> > > > > 	if (count < num_of_ib_devs) {
> > > > >
> > > > > Instead of
> > > > > 	if (!count) {
> > > > > But before giving a revised patch, how about evaluating the idea first?
> > > > >
> > > > > Yuval
> > > > Know I understand what you tried to do.
> > > > >> Thanks
> > > > >>
> > > > >> commit e4b2d06892c7f700f3d62dfef603add35269612e
> > > > >> Author: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org<mailto:yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>>
> > > > >> Date:   Mon Sep 25 05:18:00 2017 -0700
> > > > >>
> > > > >>      IB/ipoib: Remove device when one port fails to init
> > > > >>
> > > > >>      Call ipoib_remove_one when one of the IPoIB ports fails to initialize in
> > > > >>      order not to leave the module in unstable state.
> > > > >>
> > > > >>      Signed-off-by: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org<mailto:yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>>
> > > > >>      Signed-off-by: Doug Ledford 
> > > > >> <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org<mailto:dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>>
> > > > >>
> > > > >> diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c
> > > > >> b/drivers/infiniband/ulp/ipoib/ipoib_main.c
> > > > >> index 2b1b0f2..1983494 100644
> > > > >> --- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
> > > > >> +++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
> > > > >> @@ -2311,7 +2311,8 @@ static void ipoib_add_one(struct ib_device *device)
> > > > >>          }
> > > > >>
> > > > >>          if (!count) {
> > > > >> -               kfree(dev_list);
> > > > >> +               pr_err("Failed to init port, removing it\n");
> > > > >> +               ipoib_remove_one(device, dev_list);
> > > > >>                  return;
> > > > >>          }
> > > > >>
> > > > 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
