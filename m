From: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/3] IB/vmw_pvrdma: Defer activating device until vmxnet3
 link is up
Date: Wed, 18 Jan 2017 16:31:23 -0800
Message-ID: <7b3e522d-b70c-b09b-19c7-358bb5efcc91@vmware.com>
References: <cover.1484075557.git.aditr@vmware.com>
 <4b515ded56300f12cedc67253d42ab8fbc52134e.1484075557.git.aditr@vmware.com>
 <20170116073858.GA25853@mtr-leonro.local>
 <35f6cce2-00c8-16b6-e3e0-481f234bd9c9@vmware.com>
 <VI1PR0502MB30081629AE674E7F24337835D17F0@VI1PR0502MB3008.eurprd05.prod.outlook.com>
 <ad2f92cd-f120-b04a-0e94-b49915cadf02@vmware.com>
 <20170118184236.GA4864@obsidianresearch.com>
 <c44cf5cf-6096-f2df-df79-e1c8da924e84@vmware.com>
 <20170118204130.GA6422@obsidianresearch.com>
 <caee0761-e791-a56b-e8ed-609c15bdc37a@vmware.com>
 <VI1PR0502MB3008DAF4097F78DB313AE73CD17F0@VI1PR0502MB3008.eurprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <VI1PR0502MB3008DAF4097F78DB313AE73CD17F0-o1MPJYiShExKsLr+rGaxW8DSnupUy6xnnBOFsp37pqbUKgpGm//BTAC/G2K4zDHf@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "pv-drivers-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org" <pv-drivers-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, Aditya Sarwade <asarwade-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jan 18, 2017 at 10:50:54PM +0000, Parav Pandit wrote:
> Hi Adit,
> 
>> -----Original Message-----
>> From: Adit Ranadive [mailto:aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org]
>> Sent: Wednesday, January 18, 2017 2:53 PM
>> To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
>> Cc: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>; Leon Romanovsky
>> <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>; dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; pv-
>> drivers-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org; Aditya Sarwade <asarwade-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
>> Subject: Re: [PATCH 1/3] IB/vmw_pvrdma: Defer activating device until
>> vmxnet3 link is up
>> 
>> On Wed, Jan 18, 2017 at 1:41:30PM -0700, Jason Gunthorpe wrote:
>> > On Wed, Jan 18, 2017 at 12:30:07PM -0800, Adit Ranadive wrote:
>> >
>> >> In order to recover QP1 correctly after a link transition we had to
>> >> go through a register/unregister since it is placed in error state when the
>> port is down.
>> >> In this case can the MAD layer re-initialize QP1 if link transitions are
>> performed?
>> >
>> > Your driver needs to deal with this. Do whatever it takes to recover
>> > your QP1 without re-registring and do not bother the rest of the
>> > system with it.
>> 
>> Ok. We'll investigate internally on for a better recovery process for QP1.
> 
> By the time I reply, most others requested same.
> Thanks for addressing it.

Hi Doug,

Please consider taking the other two patches in this series if possible
for your next set of rc fixes.

Thanks,
Adit

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
