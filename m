From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: Create a common verbs transport library
Date: Fri, 23 Oct 2015 16:49:40 -0400
Message-ID: <20151023204938.GA18980@phlsvsds.ph.intel.com>
References: <20150929125648.GA3433@phlsvsds.ph.intel.com> <CAG9sBKPqXk671c7obj4wd8drNaxPU3gue428y3Es_BJfuC-sVQ@mail.gmail.com> <20151014184903.GA12463@phlsvsds.ph.intel.com> <CAG9sBKNKvpbRZgK+nsbuhycSnCMYnL3ObqfXmiab+akuFf99rw@mail.gmail.com> <20151015130726.GA12480@phlsvsds.ph.intel.com> <CAG9sBKNnGqdMwi+J1709JNgpW6fS1eWmc6ZN51SH2tv2Du1SGA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAG9sBKNnGqdMwi+J1709JNgpW6fS1eWmc6ZN51SH2tv2Du1SGA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Oct 15, 2015 at 05:15:38PM +0300, Moni Shoua wrote:
>> I'm thinking perhaps we'll post some stuff to GitHub and you folks can 
>> take
>> a look. We can do some back and forth before even posting patches to the
>> list. I'll check into the logistics and share the details soon?
>
>This will be great. Just send us the ref.
>If you'd like we can have an online meeting to have an initial talk.
>From my experience this can be very useful to align all on the
>subject.

I have created a branch on a GitHub repo. You can find it at:
https://github.com/weiny2/linux-kernel/tree/rdmavt

This is a starting point to get the ball rolling. I have a few more patches 
to further refine the skeleton rdmavt module. I should be able to post those 
early next week.  At that point we will have a more clear idea of what the 
API between the drivers and rdmavt will need to look like for hfi1 and qib.  
We will look for your feedback on how soft roce is going to fit in as well.

-Denny

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
