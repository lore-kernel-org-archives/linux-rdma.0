From: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 3/3] IB/sa: route SA pathrecord query through netlink
Date: Tue, 19 May 2015 19:53:04 -0400
Message-ID: <20150519235303.GA32281@phlsvsds.ph.intel.com>
References: <1431975616-23529-1-git-send-email-kaike.wan@intel.com> <1431975616-23529-4-git-send-email-kaike.wan@intel.com> <20150519190742.GO18675@obsidianresearch.com> <1828884A29C6694DAF28B7E6B8A82373A8FDD2D8@ORSMSX109.amr.corp.intel.com> <20150519204936.GB24622@obsidianresearch.com> <1828884A29C6694DAF28B7E6B8A82373A8FDD36A@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373A8FDD36A-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "Wan, Kaike" <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Hal Rosenstock (hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org)" <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Fleck, John" <john.fleck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, May 19, 2015 at 03:20:09PM -0600, Hefty, Sean wrote:
> > I'm not sure there is much use case for letting user space get
> > involved in arbitary MAD traffic..
> 
> I was thinking more about easily supporting other queries - ServiceRecords, MCMemberRecords, etc.  The only use case I'm currently aware of is PathRecords, however.
> 

I think MCMemberRecords (including joins) are good future candidates for this
interface.  The SSA work which Hal is doing had some plans for doing this.

> > Over generalizing feels like over design and doesn't let us add
> > valuable information that could help push policy decisions into user
> > space, like passing the IP and TOS, QP type, etc when available, to
> > userspace.
> 
> I agree.  This level of control would be better.  The current security model of IB seems hopelessly broken.  IMO, all path data should come from privileged users, without any ability of the app to modify it.
> 

I agree with your statement but I'm not sure how Jasons proposal helps to
control the use of PR data.  As long as verbs supports the individual setting
of PR data such as SL an application can change this data.

> Changing the protocol shouldn't be a big deal, though if you wanted to make my life easy, we could just adopt the ibacm sockets protocol directly.  :)
> 

ib_sa_path_rec_get is pretty specific in what it does.  Without over designing, this series 
adds access to the existing SA data cache (ibacm) for those users who call this
function.

I think that extending this to return an array of paths should be tackled in
future patches.  This future work could use a different protocol but I don't
think it would be part of ib_sa_path_rec_get.

Ira

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
