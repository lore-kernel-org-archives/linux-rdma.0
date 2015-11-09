From: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH ib-next 2/3] IB/core: IB/core: Allow legacy verbs through
 extended interfaces
Date: Tue, 10 Nov 2015 01:05:31 +0200
Message-ID: <20151109230531.GF20103@x-vnc01.mtx.labs.mlnx>
References: <1446745208-17733-1-git-send-email-eli@mellanox.com>
 <1446745208-17733-3-git-send-email-eli@mellanox.com>
 <CAAKD3BDq_o+J3yM1qAKg_x35Dps5Ne_ffaD_Mz55a272pwQcJg@mail.gmail.com>
 <564041C4.1090303@mellanox.com>
 <20151109223531.GB1305@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20151109223531.GB1305-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, matanbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Nov 09, 2015 at 03:35:31PM -0700, Jason Gunthorpe wrote:
> On Mon, Nov 09, 2015 at 08:48:36AM +0200, Haggai Eran wrote:
> > On 08/11/2015 17:04, Matan Barak wrote:
> > >> @@ -704,6 +719,10 @@ static ssize_t ib_uverbs_write(struct file *filp, const char __user *buf,
> > >> >         }
> > >> >
> > >> >         command = hdr.command & IB_USER_VERBS_CMD_COMMAND_MASK;
> > >> > +       if (verify_command_mask(ib_dev, command)) {
> > >> > +               ret = -EINVAL;
> > > Why did you replace ENOSYS with EINVAL?
> > 
> > I think ENOSYS is meant only to represent a system call number that
> > isn't supported. There was a change in checkpatch that now warns about
> > it [1]. I'm not sure the intention was to fix existing uses though.
> 
> Within verbs we should have two kinds of return - not supported
> request, and supported request with invalid parameters.
> 
> Maybe use EOPNOTSUPP ?
> 

What about Matan's concern regarding legacy code? Maybe we should
leave ENOSYS as that's how it is all over the IB stack code.

quote:
I think it could break old applications:
err = extended_verb(the_first_extension_we_added);
if (err == ENOSYS)
      err = legacy_verb();
if (err)
    return err;

Such applications used the first extension (that was added during the
addition of the extended verb) and when they realized it's not
supported, they dropped to the legacy verb. This change can now cause
the return of -EINVAL an early termination with an error.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
