From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: RDMA/CM and multiple QPs
Date: Tue, 8 Sep 2015 08:07:42 -0700
Message-ID: <55EEF9BE.2010002@sandisk.com>
References: <20150906064550.GA30683@infradead.org>
 <CAG53R5VZDZKiuR-jLybS1PhrT9K4GG6xTr8bOG-L0VaQgqEXSA@mail.gmail.com>
 <20150906075024.GA7845@infradead.org> <55EC5879.202@sandisk.com>
 <55EEE936.3060702@talpey.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <55EEE936.3060702-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 09/08/2015 06:57 AM, Tom Talpey wrote:
> On 9/6/2015 11:15 AM, Bart Van Assche wrote:
>> On 09/06/15 00:50, Christoph Hellwig wrote:
>>> Note that the SRP driver already in tree is a good example for this,
>>> although it doesn't use RDMA/CM and thus already operates on a
>>> per-ib_device level.
>>
>> The challenges with regard to adding RDMA/CM support to the SRP
>> initiator and target drivers are:
>> - IANA has not yet assigned a port number to the SRP protocol (see e.g.
>>
>> http://www.iana.org/assignments/service-names-port-numbers/service-names-port-numbers.xhtml).
>
> IANA doesn't do this automatically. Has anyone made the request?
>
> You might want to think through why it needs a dedicated port number
> though. iSER reuses the iSCSI port, by negotiating RDMA during login.

iSER is an iSCSI transport and that is why iSER reuses the iSCSI port 
number. SRP is a SCSI transport protocol by itself and that is why a new 
port number is needed for the SRP protocol.

>> - The login request (struct srp_login_req) is too large for the RDMA/CM.
>>     A format for the login parameters for the RDMA/CM has not yet been
>>     standardized.
>
> Are you suggesting that RDMA/CM perform the login? That seems
> like a layering issue.

Sorry but I don't see why this would be a layering issue.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
