From: Bart Van Assche <bart.vanassche-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: SRPT and SCST
Date: Mon, 9 Nov 2009 08:27:10 +0100
Message-ID: <e2e108260911082327s688a3fffi3aa103cd7cd532e@mail.gmail.com>
References: <3142CEFB1403044F9954E2DF6C85660FBB34BD@orca.penguincomputing.com>
	 <f3177b9e0911040802o7fce0f4fte02c52dfe940f582@mail.gmail.com>
	 <3142CEFB1403044F9954E2DF6C85660FBB34BF@orca.penguincomputing.com>
	 <f3177b9e0911041004t2e75d545v5cc10d5375550bde@mail.gmail.com>
	 <654FA770A883FB43BAF3CB0B1E1DAC8C01C8C4DD@orca.penguincomputing.com>
	 <4AF29201.6000606@penguincomputing.com> <4AF2D2B8.5080304@vlnb.net>
	 <e2e108260911051034o43db58cdi65b84ce46219bb94@mail.gmail.com>
	 <654FA770A883FB43BAF3CB0B1E1DAC8C01C8C4F9@orca.penguincomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <654FA770A883FB43BAF3CB0B1E1DAC8C01C8C4F9-/U8SqUwOx9/OOpeOfUw7maQk6oIRg43YAL8bYrjMMd8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Philip Pokorny <ppokorny-pabcTyWEv4ZW60MLeMDbCVaTQe2KTcn/@public.gmane.org>
Cc: Vladislav Bolkhovitin <vst-d+Crzxg7Rs0@public.gmane.org>, scst-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Arend Dittmer <adittmer-pabcTyWEv4ZW60MLeMDbCVaTQe2KTcn/@public.gmane.org>, Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Nov 6, 2009 at 3:54 AM, Philip Pokorny
<ppokorny-pabcTyWEv4ZW60MLeMDbCVaTQe2KTcn/@public.gmane.org> wrote:
>
> On Thu, Nov 5, 2009 at 2:27 PM, Vladislav Bolkhovitin <vst-d+Crzxg7Rs0@public.gmane.org> wrote:
> >
> > Philip Pokorny, on 11/05/2009 11:51 AM wrote:
> >>
> >> Chris Worley asked that we post this to scst and linux-rdma lists for discussion.
> >>
> >
> > Looks like ib_post_send() in srpt_perform_rdmas() returned ENOMEM and then srpt_xfer_data() "forgot" to unmapped corresponding SG with all related consequences.
>
> I would like to add the following to the above analysis:
> * The function srpt_xfer_data() calls srpt_perform_rdmas(). The last
> function calls ib_post_send() repeatedly. ib_post_send() can fail
> because the work queue on which the send request should be posted is
> full. When processing an sg list with multiple entries, it is possible
> that some entries get posted to the work queue and some not.
> * If this happens, the last send posted on the work queue won't
> trigger a completion event (this is a bug in srpt_perform_rdmas()).
> * If the srpt_perform_rdmas() call inside srpt_xfer_data() fails, it
> is possible that some of the sg list entries have been posted on the
> IB work queue and some not. So error recovery will be more complex
> than just a single call to ib_dma_unmap_sg().
>
> =======
> Is there something I could code up to sleep, pause or retry the calls to ib_post_send if they fail?

Proper error handling has to be implemented in srpt_xfer_data(). Also,
measures have to be taken such that no more work is posted on the IB
queue than the reserved size. Which value are you using for
SCST_MAX_TGT_DEV_COMMANDS (defined in scst/src/scst_priv.h) ?

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
