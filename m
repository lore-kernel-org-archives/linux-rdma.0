From: Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org>
Subject: Re: 281e36cbaf causes FlexBoot iSCSI errors
Date: Fri, 16 Jun 2017 14:12:45 -0600
Message-ID: <CAANLjFo2zRWg_-ExvKp1bjkEahNdSSSG25JEaUHvV0MqHfZ3bg@mail.gmail.com>
References: <CAANLjFpJHvGmVX54_DZm80tbP094UwEWyhPs8KCocg4YzNyq=A@mail.gmail.com>
 <1497642890.2621.12.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1497642890.2621.12.camel-Sjgp3cTcYWE@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Jun 16, 2017 at 1:54 PM, Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org> wrote:
> On Fri, 2017-06-16 at 13:41 -0600, Robert LeBlanc wrote:
>> 281e36cbaf : iscsi-target: Drop work-around for legacy GlobalSAN initiator
>
> Hello Robert,
>
> Since that commit went in through the target tree, please report this to
> target-devel-u79uwXL29TaiAVqoAR/hOA@public.gmane.org
>
> Bart.

Bart,

Thanks, I'll report to them as well. I do think the commit is the
right approach and that FlexBoot needs to be fixed to more closely
follow the standard, which there should be some Mellanox folks here
that can get the ball rolling in that regard.

----------------
Robert LeBlanc
PGP Fingerprint 79A2 9CA4 6CC4 45DD A904  C70E E654 3BB2 FA62 B9F1
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
