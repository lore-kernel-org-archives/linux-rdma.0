From: Sreedhar Kodali <srkodali-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: RE: [PATCH v2 3/4] rsockets: distribute completion queue vectors
 among multiple cores
Date: Wed, 17 Sep 2014 11:24:02 +0530
Message-ID: <8ef183ac3ab0735f47108b33702f9e46@imap.linux.ibm.com>
References: <f028f54b9900ee34fcd1abd1d90d10e6@imap.linux.ibm.com>
 <5409DB0D.6080103@acm.org>
 <850a2835b5917f6da62af3d1ea0288fd@imap.linux.ibm.com>
 <540D50E9.5050709@acm.org>
 <a8ac21f3c9d7c802ab089bc0d432e40b@imap.linux.ibm.com>
 <540DF3CC.1060304@acm.org>
 <edc2b05703209d2a7626a31abb170ceb@imap.linux.ibm.com>
 <ef556922e7b766360a38df904dff1c70@imap.linux.ibm.com>
 <5416ABFB.7040701@acm.org>
 <d5804c38cb47bcc79eb3962cf8ca6989@imap.linux.ibm.com>
 <1828884A29C6694DAF28B7E6B8A8237399DD3DA8@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237399DD3DA8-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, pradeeps-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 2014-09-16 10:27, Hefty, Sean wrote:
>> Thanks for your detailed thoughts and insights into comp vector
>> assignment.  As you rightly pointed out, let's hear from wider
>> community as well before we attempt another iteration on the path.
>> I have included below some details about the latest patch to
>> understand where we are currently.
> 
> Are there any similar mechanisms defined elsewhere that we can use as 
> guidance?
> 
> I don't recall, does completion vector 0 refer to a specific vector or
> does it mean use a default assignment?
> 
> - Sean

Hi Sean,

Not sure about similar mechanisms but some references to irq balancing
available on the net.  I think, comp vector 0 is a specific vector that
is used by default.

Thank You.

- Sreedhar

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
