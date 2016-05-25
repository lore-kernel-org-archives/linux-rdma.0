From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: Email problems
Date: Wed, 25 May 2016 14:05:36 -0700
Message-ID: <47e7fa77-df99-dfc0-d91e-2d6c8e8e8dfe@sandisk.com>
References: <bbc79ac4-6f84-2013-b493-18ec2e9bce9b@redhat.com>
 <9C6B67F36DCAFC479B1CF6A967258A8C7DDBC720@ORSMSX115.amr.corp.intel.com>
 <b07e29e0-4349-3927-7f61-ba66a463cf74@redhat.com>
 <8f47e860-7278-aea5-73a4-ca21d46b3778@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <8f47e860-7278-aea5-73a4-ca21d46b3778-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Woodruff Robert J <robert.j.woodruff-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 05/25/2016 01:42 PM, Doug Ledford wrote:
> I've narrowed this down to a Thunderbird issue.  Whenever it does the
> whole "drop some of the recipients" thing, the Error Console has this
> logged at the same time as the sent email:
>
> Timestamp: 05/25/2016 04:07:57 PM
> Error: DEPRECATION WARNING: Encoding to non-UTF-8 values is obsolete
> You may find more details about this deprecation at:
> http://bugzilla.mozilla.org/show_bug.cgi?id=790855
> resource://gre/components/mimeJSComponents.js 438
> MimeConverter.prototype.encodeMimePartIIStr_UTF8
> chrome://messenger/content/messengercompose/MsgComposeCommands.js 2849
> GenericSendMessage
> chrome://messenger/content/messengercompose/MsgComposeCommands.js 2930
> SendMessage
> chrome://messenger/content/messengercompose/MsgComposeCommands.js 590
> defaultController.commands.cmd_sendButton.doCommand
> chrome://messenger/content/messengercompose/MsgComposeCommands.js 762
> defaultController.doCommand
> chrome://global/content/globalOverlay.js 100 goDoCommand
> chrome://messenger/content/messengercompose/messengercompose.xul 1 oncommand
>
> Source File: resource://gre/modules/Deprecated.jsm
> Line: 79
>
> I've filed a bug at Red Hat, but in case I'm not the only one using
> Thunderbird, I just wanted to point this out.

Thanks Doug for having tracked this down. I'm using Thunderbird 45.1.0 
but I have not yet seen this issue.

Bart.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
