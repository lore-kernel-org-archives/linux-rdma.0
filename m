From: "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
Subject: Re: SQ overflow seen running isert traffic with high block sizes
Date: Tue, 23 Jan 2018 23:25:17 -0800
Message-ID: <1516778717.24576.319.camel@haakon3.daterainc.com>
References: <BN3PR07MB25784033E7FCD062FA0A7855F8DD0@BN3PR07MB2578.namprd07.prod.outlook.com>
         <210f538f-8c98-f480-64fc-f2124ed6d01b@grimberg.me>
         <BN3PR07MB25786338EADC77A369A6D493F8DD0@BN3PR07MB2578.namprd07.prod.outlook.com>
         <1499970579.7987.8.camel@haakon3.daterainc.com>
         <BN3PR07MB2578E6561CC669922A322245F8A00@BN3PR07MB2578.namprd07.prod.outlook.com>
         <20171006224025.GA23364@ssaleem-MOBL4.amr.corp.intel.com>
         <1515992195.24576.156.camel@haakon3.daterainc.com>
         <CY1PR0701MB2012E53C69D1CE3E16BA320B88EB0@CY1PR0701MB2012.namprd07.prod.outlook.com>
         <20180115152236.GA15484@ssaleem-MOBL4.amr.corp.intel.com>
         <1516269522.24576.274.camel@haakon3.daterainc.com>
         <20180118175316.GA11338@chelsio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180118175316.GA11338-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Potnuri Bharat Teja <bharat-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Cc: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Kalderon, Michal" <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Elior, Ariel" <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, target-devel <target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Potnuri & Co,

On Thu, 2018-01-18 at 23:23 +0530, Potnuri Bharat Teja wrote:
> Hi Nicholas, 
> thanks for the suggestions. Comments below.
> 
> On Thursday, January 01/18/18, 2018 at 15:28:42 +0530, Nicholas A. Bellinger wrote:
> > Hi Shiraz, Michal & Co,
> > 
> > Thanks for the feedback.  Comments below.
> > 
> > On Mon, 2018-01-15 at 09:22 -0600, Shiraz Saleem wrote:
> > > On Mon, Jan 15, 2018 at 03:12:36AM -0700, Kalderon, Michal wrote:
> > > > > From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-
> > > > > owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Nicholas A. Bellinger
> > > > > Sent: Monday, January 15, 2018 6:57 AM
> > > > > To: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > > > > Cc: Amrani, Ram <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>; Sagi Grimberg
> > > > > <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Elior, Ariel
> > > > > <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>; target-devel <target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>;
> > > > > Potnuri Bharat Teja <bharat-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
> > > > > Subject: Re: SQ overflow seen running isert traffic with high block sizes
> > > > > 
> > > > > Hi Shiraz, Ram, Ariel, & Potnuri,
> > > > > 
> > > > > Following up on this old thread, as it relates to Potnuri's recent fix for a iser-
> > > > > target queue-full memory leak:
> > > > > 
> > > > > https://www.spinics.net/lists/target-devel/msg16282.html
> > > > > 
> > > > > Just curious how frequent this happens in practice with sustained large block
> > > > > workloads, as it appears to effect at least three different iwarp RNICS (i40iw,
> > > > > qedr and iw_cxgb4)..?
> > > > > 
> > > > > Is there anything else from an iser-target consumer level that should be
> > > > > changed for iwarp to avoid repeated ib_post_send() failures..?
> > > > > 
> > > > Would like to mention, that although we are an iWARP RNIC as well, we've hit this
> > > > Issue when running RoCE. It's not iWARP related. 
> > > > This is easily reproduced within seconds with IO size of 5121K
> > > > Using 5 Targets with 2 Ram Disk each and 5 targets with FileIO Disks each.
> > > > 
> > > > IO Command used:
> > > > maim -b512k -T32 -t2 -Q8 -M0 -o -u -n -m17 -ftargets.dat -d1
> > > > 
> > > > thanks,
> > > > Michal
> > > 
> > > Its seen with block size >= 2M on a single target 1 RAM disk config. And similar to Michals report;
> > > rather quickly, in a matter of seconds.
> > > 
> > > fio --rw=read --bs=2048k --numjobs=1 --iodepth=128 --runtime=30 --size=20g --loops=1 --ioengine=libaio 
> > > --direct=1 --invalidate=1 --fsync_on_close=1 --norandommap --exitall --filename=/dev/sdb --name=sdb 
> > > 
> > 
> > A couple of thoughts.
> > 
> > First, would it be helpful to limit maximum payload size per I/O for
> > consumers based on number of iser-target sq hw sges..?
> yes, I think HW num sge needs to be propagated to iscsi target.
> > 
> > That is, if rdma_rw_ctx_post() -> ib_post_send() failures are related to
> > maximum payload size per I/O being too large there is an existing
> 
> Yes they are IO size specific, I observed SQ overflow with fio for IO sizes above
> 256k and for READ tests only with chelsio(iw_cxgb4) adapters.

Thanks for confirming.

> > target_core_fabric_ops mechanism for limiting using SCSI residuals,
> > originally utilized by qla2xxx here:
> > 
> > target/qla2xxx: Honor max_data_sg_nents I/O transfer limit
> > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=8f9b565482c537821588444e09ff732c7d65ed6e
> > 
> > Note this patch also will return a smaller Block Limits VPD (0x86)
> > MAXIMUM TRANSFER LENGTH based on max_data_sg_nents * PAGE_SIZE, which
> > means for modern SCSI initiators honoring MAXIMUM TRANSFER LENGTH will
> > automatically limit maximum outgoing payload transfer length, and avoid
> > SCSI residual logic.
> > 
> > As-is, iser-target doesn't a propagate max_data_sg_ents limit into
> > iscsi-target, but you can try testing with a smaller value to see if
> > it's useful.  Eg:
> > 
> > diff --git a/drivers/target/iscsi/iscsi_target_configfs.c b/drivers/target/iscsi/iscsi_target_configf
> > index 0ebc481..d8a4cc5 100644
> > --- a/drivers/target/iscsi/iscsi_target_configfs.c
> > +++ b/drivers/target/iscsi/iscsi_target_configfs.c
> > @@ -1553,6 +1553,7 @@ static void lio_release_cmd(struct se_cmd *se_cmd)
> >         .module                         = THIS_MODULE,
> >         .name                           = "iscsi",
> >         .node_acl_size                  = sizeof(struct iscsi_node_acl),
> > +       .max_data_sg_nents              = 32, /* 32 * PAGE_SIZE = MAXIMUM TRANSFER LENGTH */
> >         .get_fabric_name                = iscsi_get_fabric_name,
> >         .tpg_get_wwn                    = lio_tpg_get_endpoint_wwn,
> >         .tpg_get_tag                    = lio_tpg_get_tag,
> > 
> With above change, SQ overflow isn't observed. I started of with max_data_sg_nents = 16.

OK, so max_data_sg_nents=32 (MAXIMUM TRANSFER SIZE=128K with 4k pages)
avoids SQ overflow with iw_cxgb4.

What is iw_cxgb4 reporting to isert_create_cq():attr.cap.max_send_sge..?

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
