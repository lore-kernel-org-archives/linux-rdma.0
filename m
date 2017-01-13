From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: NFSoRDMA Fails for max_sge Less Than 18
Date: Fri, 13 Jan 2017 16:45:57 -0600
Message-ID: <063801d26dee$ce257110$6a705330$@opengridcomputing.com>
References: <SN1PR07MB2207F28F05DC6E22B03CC516F8660@SN1PR07MB2207.namprd07.prod.outlook.com> <FE817A76-28A7-4AEC-AF1E-01DE15790E43@oracle.com> <027101d26c2c$c94467f0$5bcd37d0$@opengridcomputing.com> <28B0D906-7BDB-4B87-94E9-6BE263BFBFF7@oracle.com> <038901d26c44$67d6c4f0$37844ed0$@opengridcomputing.com> <383D1FFB-346B-40E9-A174-606F13AFF849@oracle.com> <03b301d26c47$f154a5a0$d3fdf0e0$@opengridcomputing.com> <A7A39994-66C6-4467-837B-288348C0CC53@oracle.com> <062101d26dee$46e78df0$d4b6a9d0$@opengridcomputing.com> <906A1B75-67E9-4D10-AD87-18F694F54818@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <906A1B75-67E9-4D10-AD87-18F694F54818-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Chuck Lever' <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: "'Amrani, Ram'" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "'Elior, Ariel'" <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "'Kalderon, Michal'" <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, 'List Linux RDMA Mailing' <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, 'Hariprasad S' <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, 'Faisal Latif' <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Doug Ledford' <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> > Hey Chuck, Chelsio confirmed mounts fail with 4.10-rc.  So can you get a
fix
> > in 4.10-rc (and back to 4.9 if the regression is there) to ensure at
least a
> > max_sge of 4 is supported?
> 
> Posted earlier today:
> 
> Available in the "nfs-rdma-for-4.10-rc" topic branch of this git repo:
> 
> git://git.linux-nfs.org/projects/cel/cel-2.6.git

Great!  I'll ask Chelsio to verify it.

Thanks,

Steve.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
