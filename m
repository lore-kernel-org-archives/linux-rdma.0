From: "ira.weiny" <ira.weiny@intel.com>
Subject: Re: [PATCH 4/8] staging/rdma/hfi1: remove unneeded goto done
Date: Wed, 11 Nov 2015 10:15:53 -0500
Message-ID: <20151111151552.GA13414@phlsvsds.ph.intel.com>
References: <1447220589-9067-1-git-send-email-ira.weiny@intel.com>
 <1447220589-9067-5-git-send-email-ira.weiny@intel.com>
 <20151111090108.GB18797@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
Content-Disposition: inline
In-Reply-To: <20151111090108.GB18797@mwanda>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: devel@driverdev.osuosl.org, gregkh@linuxfoundation.org, dledford@redhat.com, dennis.dalessandro@intel.com, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Nov 11, 2015 at 12:01:08PM +0300, Dan Carpenter wrote:
> On Wed, Nov 11, 2015 at 12:43:05AM -0500, ira.weiny@intel.com wrote:
> > From: Ira Weiny <ira.weiny@intel.com>
> > 
> > This goto done is followed by an if (ret) break in the outer switch clause.  It
> > is unnecessary.
> > 
> > Signed-off-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
> > Signed-off-by: Ira Weiny <ira.weiny@intel.com>
> > ---
> >  drivers/staging/rdma/hfi1/diag.c | 3 +--
> >  1 file changed, 1 insertion(+), 2 deletions(-)
> > 
> > diff --git a/drivers/staging/rdma/hfi1/diag.c b/drivers/staging/rdma/hfi1/diag.c
> > index 2bb857b2a103..556a47591989 100644
> > --- a/drivers/staging/rdma/hfi1/diag.c
> > +++ b/drivers/staging/rdma/hfi1/diag.c
> > @@ -1053,7 +1053,6 @@ static long hfi1_ioctl(struct file *fp, unsigned int cmd, unsigned long arg)
> >  				break;
> >  			default:
> >  				ret = -EINVAL;
> > -				goto done;
> >  			}
> >  			ret = set_link_state(ppd, dev_state);
> >  			break;
> 
> Wut?  No it's not.

Sorry, you are correct at this point in the series.

I got over zealous with my splitting of this patch.  This needs to be squashed
into 

staging/rdma/hfi1: Return immediately on error

Which returns here.

Ira
