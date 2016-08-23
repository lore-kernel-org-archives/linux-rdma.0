From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: 4.7.0 ib_srpt Regression - 4.6.4 Got failed path rec status -22
 got worse on 4.7.0
Date: Tue, 23 Aug 2016 08:26:49 -0700
Message-ID: <d8575baf-7f5f-1597-3925-c3523f7b5cd7@sandisk.com>
References: <CA+X5Wn46GGnqijVS54A_45_D8g_0cvcZ3iAYbt2J6syiKwqNGA@mail.gmail.com>
 <39412892-aab7-5bf9-7a19-be311dc32050@sandisk.com>
 <CA+X5Wn7KbG-6Hg2JdOJhteXezgMS5O6DkixOjB3idoWu=UXKJQ@mail.gmail.com>
 <CA+X5Wn6zJp2nGUF2TNjtY28gG8-Ho-yyO2a49JUm2ph0qJ7zDQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CA+X5Wn6zJp2nGUF2TNjtY28gG8-Ho-yyO2a49JUm2ph0qJ7zDQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: james harvey <jamespharvey20-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "hch-jcswGhMUV9g@public.gmane.org" <hch-jcswGhMUV9g@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 08/23/2016 01:53 AM, james harvey wrote:
> Turns out if the target is on 4.7.0, I can't use SRP under an
 > circumstances - even with the initiator booted from a hard drive.

Hello James,

Please avoid v4.7.0 and use v4.7.1 instead. The introduction of the RDMA 
API in the IB core in v4.7.0 caused a regression in the ib_srpt driver 
and v4.7.1 is the first kernel that includes all necessary fixes.

Bart.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
