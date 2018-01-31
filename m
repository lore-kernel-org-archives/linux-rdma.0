From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH rdma-core] iwpmd: fix double mutex unlock
Date: Wed, 31 Jan 2018 15:12:30 -0600
Message-ID: <021201d39ad8$349bb730$9dd32590$@opengridcomputing.com>
References: <1517413071-20438-1-git-send-email-bharat@chelsio.com>       <010901d39aa9$d4d66fd0$7e834f70$@opengridcomputing.com>         <012d01d39aad$228c34f0$67a49ed0$@opengridcomputing.com> <1517432802.19117.41.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1517432802.19117.41.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Doug Ledford' <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, 'Potnuri Bharat Teja' <bharat-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, jgg-uk2M96/98Pc@public.gmane.org, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

> Subject: Re: [PATCH rdma-core] iwpmd: fix double mutex unlock
> 
> On Wed, 2018-01-31 at 10:04 -0600, Steve Wise wrote:
> > > >
> > > > pthread_mutex_unlock() is used twice and this patch fixes it.
> > > >
> > > > Fixes: be3fbf85b ("iwpmd: use ccan list.h for pending_messages")
> > > > Signed-off-by: Potnuri Bharat Teja <bharat-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
> > > > ---
> > > >  iwpmd/iwarp_pm_helper.c | 1 -
> > > >  1 file changed, 1 deletion(-)
> > > >
> > > > diff --git a/iwpmd/iwarp_pm_helper.c b/iwpmd/iwarp_pm_helper.c
> > > > index bebc151f329b..b8c230189d50 100644
> > > > --- a/iwpmd/iwarp_pm_helper.c
> > > > +++ b/iwpmd/iwarp_pm_helper.c
> > > > @@ -578,7 +578,6 @@ int add_iwpm_pending_msg(iwpm_send_msg
> > > > *send_msg)
> > > >
> > > >  	pthread_mutex_lock(&pending_msg_mutex);
> > > >  	list_add(&pending_messages, &pending_msg->entry);
> > > > - 	pthread_mutex_unlock(&pending_msg_mutex);
> > > >  	pthread_mutex_unlock(&pending_msg_mutex);
> > > >  	/* signal the thread that a new message has been posted */
> > > >  	pthread_cond_signal(&cond_pending_msg);
> > >
> > > Good catch.
> > >
> > > Reviewed-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
> >
> > And this definitely needs to flow to stable.
> >
> 
> Applied to master branch, thanks.
> 

Thanks Doug.  Do I need to do some process magic to get it into stable and spin a 16.x.y point release for the EWG to pull into OFED-4.8-2?  

Steve.



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
