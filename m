From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH v2 03/12] IB/ocrdma: Improve size determinations in ten
 functions
Date: Mon, 24 Apr 2017 12:38:58 -0400
Message-ID: <1493051938.3041.52.camel@redhat.com>
References: <fc421509-4069-da8a-b308-60b49ea91ada@users.sourceforge.net>
         <1492720999.3041.18.camel@redhat.com>
         <86425035-7da8-d2b1-8544-d4f7540d50c6@users.sourceforge.net>
         <755f6c2c-03a2-7248-a5e3-9190d119cdaf@users.sourceforge.net>
         <20170423073311.GA14088@mtr-leonro.local>
         <1f122892-7e67-a7ca-ae7f-7ac8e2b7a037@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <1f122892-7e67-a7ca-ae7f-7ac8e2b7a037@intel.com>
Sender: kernel-janitors-owner@vger.kernel.org
To: Dennis Dalessandro <dennis.dalessandro@intel.com>, Leon Romanovsky <leon@kernel.org>
Cc: SF Markus Elfring <elfring@users.sourceforge.net>, Devesh Sharma <devesh.sharma@avagotech.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Sean Hefty <sean.hefty@intel.com>, Selvin Xavier <selvin.xavier@avagotech.com>, Yuval Shaia <yuval.shaia@oracle.com>, linux-rdma@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Mon, 2017-04-24 at 08:54 -0400, Dennis Dalessandro wrote:
> On 04/23/2017 03:33 AM, Leon Romanovsky wrote:
> > 
> > On Sat, Apr 22, 2017 at 04:36:19PM +0200, SF Markus Elfring wrote:
> > > 
> > > From: Markus Elfring <elfring@users.sourceforge.net>
> > > Date: Sat, 22 Apr 2017 13:26:49 +0200
> > > 
> > > Replace the specification of data types by pointer dereferences
> > > as the parameter for the operator "sizeof" to make the
> > > corresponding size
> > > determinations a bit safer according to the Linux coding style
> > > convention.
> > > 
> > > Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
> > > ---
> > > 
> > > v2:
> > > Changes were rebased on source files from Linux next-20170421.
> > > These were recombined as requested by Doug Ledford.
> > 
> > Hi Doug,
> > 
> > I recommend you to be extra cautious with this blind automatic
> > conversions. It requires inspection that every size before and
> > after
> > match each other.
> > 
> > I already asked it and would be like to repeat it. Please DON'T
> > take any
> > patches from Markus, which are related to mlx4/mlx5/rxe without our
> > explicit
> > review of them.
> 
> I agree with Leon here, and these sort of find/replace automagic 
> clean-up patches make me nervous sometimes.

OK, the easiest way to make sure that only the things you want from his
patches get through is to have you pull them into a branch and submit
them yourself.  I'll only take the ones you submit to me, that way
there is no confusion about whether or not you have checked them and
approved them.

> Markus, what have you done to ensure your patches don't break
> anything?
> 
> -Denny
> 
-- 
Doug Ledford <dledford@redhat.com>
    GPG KeyID: B826A3330E572FDD
   
Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

