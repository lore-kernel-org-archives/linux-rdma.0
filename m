From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH 1/3 v5] IB/srp: Preparation for transmit ring response allocation
Date: Thu, 19 Aug 2010 19:28:47 +0200
Message-ID: <AANLkTinAm89s3Zg7Fc8K0g9RFfAjjiusAgKsrQieJgJE@mail.gmail.com>
References: <201008162054.06416.bvanassche@acm.org>
	<1282175086.25848.17.camel@obelisk.thedillows.org>
	<AANLkTim=ESAvKNCocpCKGuqaGVnO4FMhBck9+NaoRBZB@mail.gmail.com>
	<1282214698.25848.35.camel@obelisk.thedillows.org>
	<AANLkTikNUWtw5fHR44HEWK=ceXQ+mxKSKKS1=qrgudXB@mail.gmail.com>
	<1282238719.9393.3.camel@lap75545.ornl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1282238719.9393.3.camel-FqX9LgGZnHWDB2HL1qBt2PIbXMQ5te18@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Aug 19, 2010 at 7:25 PM, David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org> wrote:
> On Thu, 2010-08-19 at 18:53 +0200, Bart Van Assche wrote:
>> On Thu, Aug 19, 2010 at 12:44 PM, David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org> wrote:
>> > Put the assignment on the same line as the declaration and I'll deal
>> > with the name.
>>
>> Putting the rsv assignment on the same line as its declaration would
>> make that line exceed 80 columns and hence would trigger a checkpatch
>> complaint, so it's better to keep it as it is now.
>
> I didn't check it with checkpatch, but vi tells me it is 78 characters.

That line was 78 characters long before SRP_REQ_TASK_MGMT was renamed
into SRP_TX_IU_REQ_TASK_MGMT, but exceeds 80 characters after renaming
that constant.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
