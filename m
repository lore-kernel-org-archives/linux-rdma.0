From: Honggang LI <honli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [rdma-core/srp_daemon PATCH] Correct method field for PathRecord
 request
Date: Thu, 13 Apr 2017 21:58:32 +0800
Message-ID: <20170413135832.GB8255@dhcp-13-42.nay.redhat.com>
References: <1491924533-2548-1-git-send-email-honli@redhat.com>
 <20170411154944.GA19917@obsidianresearch.com>
 <20170412132923.GB16375@dhcp-13-42.nay.redhat.com>
 <d5a9d1a8-6c38-51f2-d444-a6942db406f9@dev.mellanox.co.il>
 <20170412141800.GA20223@dhcp-13-42.nay.redhat.com>
 <6e04d44e-fab3-1477-7de4-d3c679301f38@dev.mellanox.co.il>
 <20170412144946.GC20223@dhcp-13-42.nay.redhat.com>
 <89c5ad40-cb4d-8b4d-48b3-e53351fb64af@dev.mellanox.co.il>
 <56ade261-811d-16df-6b3f-7d08c07c882f@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <56ade261-811d-16df-6b3f-7d08c07c882f-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Apr 12, 2017 at 01:39:02PM -0400, Hal Rosenstock wrote:
> On 4/12/2017 12:51 PM, Hal Rosenstock wrote:
> > On 4/12/2017 10:49 AM, Honggang LI wrote:
> >> On Wed, Apr 12, 2017 at 10:34:47AM -0400, Hal Rosenstock wrote:
> >>> On 4/12/2017 10:18 AM, Honggang LI wrote:
> >>>> On Wed, Apr 12, 2017 at 09:34:20AM -0400, Hal Rosenstock wrote:
> >>>>> On 4/12/2017 9:29 AM, Honggang LI wrote:
> >>>>>> On Tue, Apr 11, 2017 at 09:49:44AM -0600, Jason Gunthorpe wrote:
> >>>>>>> On Tue, Apr 11, 2017 at 11:28:53PM +0800, Honggang LI wrote:
> >>>>>>>> From: Honggang Li <honli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> >>>>>>>>
> >>>>>>>> According to InfiniBand Architecture Release 1.2.1, Table 208
> >>>>>>>> Example PathRecord Request MAD Header Fields, MADHeader:Method
> >>>>>>>> should setup to 0x12 (SubnAdmGetTable()).
> >>>>>>>
> >>>>>>> That is just an example, Table 192 shows that Get and GetTable are
> >>>>>>> both valid query types.
> >>>>>>
> >>>>>> I don't understand this as "Table 192 PortInfoRecord" seems nothing to
> >>>>>> do with PathRecord request.
> >>>>>
> >>>>> In IBA 1.3 volume 1, it's Table 209 Subnet Administration
> >>>>> Attribute/Method Map shows PathRecord methods are Get and GetTable.
> >>>>>
> >>>>
> >>>> http://www.intel.com/content/dam/www/public/us/en/documents/product-briefs/truescale-infiniband-12300-switch-brief.pdf
> >>>> Interoperability
> >>>> • Compliant with IBTA* specifications 1.0a, 1.1, 1.2, and 1.2.
> >>>>
> >>>> It seems the embedded subnet manager does not support IBA 1.3
> >>>
> >>> It's same for IBA 1.2.1. This part hasn't changed.
> >>>
> >>>>>>>
> >>>>>>> I however expect that the SM will fail when using GetTable if the
> >>>>>>> query returns more than one result, could that be what is happening?
> >>>>>>> When you convert it to GET_TABLE does it return more than one result?
> >>>>>>
> >>>>>> strace output shows srptools always received MAD packet in 320 bytes. So
> >>>>>> the embedded subnet manager only returns one result.
> >>>>>
> >>>>> What is MAD status ?
> >>>>
> >>>> ib_user_mad->status     = 0x0
> >>>>
> >>>> I attached the MAD packet dump out with strace. Please see the
> >>>> attachments p4.in amd p4.decode.
> >>>
> >>> p4.decode has:
> >>> rp_dm_rmpp_sa_mad->method		= 0x81 //IB_MAD_METHOD_GET_RESP
> >>> opensm/include/iba/ib_types.h // GetResp() Method (13.4.5)
> >>>
> >>> Proper response to GetTable (0x12) method is GetTableResponse (0x92)
> >>> method but this is GetResp (0x81) response.
> >>
> >> Yes, you are right. p4.decode was captured with unpatched upstream srptools-1.0.3.
> > 
> > against the embedded SM ? If so, this response looks (mostly) good to me and should be accepted by srp_daemon. I think I see the issue in srp_daemon: it's due to the check of the attribute offset which is not being set in the response:
> > 
> >                 size = ib_get_attr_size(in_sa_mad->attr_offset);
> >                 if (!size) {
> >                         if (config->verbose)
> >                                 printf("PathRec Query did not find any targets "
> >                                        "over P_Key %x\n", pkey);
> >                         continue;
> >                 }
> > 
> > p4.decode has:
> > srp_dm_rmpp_sa_mad->attr_offset		= 0x0
> > 
> > Since a get rather than get table is being used, a good MAD status means that a valid PR was returned and there is no need for this check.
> > 
> > Would you try using the original get method without this code block and verify that it works with the embedded SM ?
> 
> Just submitted PR for this:
> https://github.com/linux-rdma/rdma-core/pull/116

Those three patches PASSED the test.

> I can post patch if you like.

Please fix the typo I mentioned in the PR and post those three patches.

thanks
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
