From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: Re: protection domain question
Date: Sun, 10 Apr 2016 17:27:03 +0300
Message-ID: <570A62B7.9020200@grimberg.me>
References: <20160409190331.GA23186@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160409190331.GA23186-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


> As far as I can tell from reading the Verbs spec the raison d'=C3=AAt=
refor
> protection domains is to allow associating MRs with different address
> spaces in userspace programs.

The PD number is enforced when accessing the associated MRs (via the
associated QPs). So if someone is accessing a MR that is associated
with a PD via a queue-pair that is not it will fail (its a security
thing).

> Is there any good reason to have each kernel driver create it's own P=
Ds
> instead of simply creating one per device and sticking it into the
> ib_device structure?

There is a theoretical breach here. Say you're connected with a srp
channel to a target, and you send out rkey X to your peer. In case
there is a man-in-the-middle who sniffs it, he can theoretically
read/write to your rkey by connecting to IPoIB in RC mode (which
will connect to anyone).

The fact that srp has it's own PD prevents this from happening.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
