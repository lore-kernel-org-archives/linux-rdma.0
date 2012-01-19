From: Jack Morgenstein <jackm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: RE: [PATCH 2/2] IB/mad: Return unsupported for MADs as appropriate
Date: Thu, 19 Jan 2012 08:13:24 +0000
Message-ID: <86FC963EFF71CB46A06F144F8602FEF24EF506F5@MTLDAG02.mtl.com>
References: <20120118084255.18560.40844.stgit@kop-dev-sles11-04.qlogic.org>
 <20120118084311.18560.22509.stgit@kop-dev-sles11-04.qlogic.org>
 <4F169940.5090007@mellanox.com>
 <4C2744E8AD2982428C5BFE523DF8CDCB5CD590F65E@MNEXMB1.qlogic.org>
 <CAL1RGDUh1AEMdok69RJP1cTchvCW7C7HJFTmYm=kUNu7hWA_5Q@mail.gmail.com>
 <1828884A29C6694DAF28B7E6B8A823732DC00DEE@ORSMSX101.amr.corp.intel.com>
 <20120118185620.GJ2892@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120118185620.GJ2892-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Jason Gunthorpe' <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Swapna Thete <swapna.thete-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

I see a problem here.  If a node receives an SMInfo MAD (which is SMI -- LID-Route or Direct-Route classes), it would look bizarre to indicate that an entire SMI class is not supported, when fact OpenSM is simply not answering a "get" on the SMInfo **attribute** .  In this case, #3 is correct (and #1 is NOT correct -- the HCA's SMA would still support SMI mads!).

In other cases, where an entire class is not supported (e.g., dev_mgt or SNMP), we can still probably return #3, since the attributes tend not to overlap between classes (i.e., each class has a mostly unique set of attributes).  Since it would be a nightmare to differentiate between returning #1 and #3 (if this is at all possible -- I believe that in real time it is impossible to tell if an entire class has just gone missing (or was never supported), or just the specific attribute, such as SM_INFO, for a given class), I suggest we return #3.

-Jack

-----Original Message-----
From: Jason Gunthorpe [mailto:jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org]
Sent: Wednesday, January 18, 2012 8:57 PM
To: Hefty, Sean
Cc: Roland Dreier; Swapna Thete; Or Gerlitz; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Jack Morgenstein
Subject: Re: [PATCH 2/2] IB/mad: Return unsupported for MADs as appropriate

On Wed, Jan 18, 2012 at 05:20:13PM +0000, Hefty, Sean wrote:
> > Surely we should be picking the response status based on the IB spec
> > rather than on the error message that some arbitrary tool prints?
>
> agreed - these are the basic choices:
>
> Code for invalid field
> 0 - no invalid fields
> 1 - Bad version. Either the base version, or the class version, or the
> combination of the two is not supported.
> 2 - The method specified is not supported
> 3 - The method/attribute combination is not supported
>
> none of which seem that great...  IMO, unsupported class version seems
> as good as any.

Figure 169 specifies the validation flow. 1 is the correct reply for 'Management class is not supported on this port'.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
