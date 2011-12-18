From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH 04/14] ib_srp: Set block layer timeout
Date: Sun, 18 Dec 2011 06:53:32 -0500
Message-ID: <CAO+b5-oiMkrge0FAyRx66kzBU6kzMHKO3L0j=b0wyoivyvpMoQ@mail.gmail.com>
References: <201112011954.25811.bvanassche@acm.org>
	<201112011959.11956.bvanassche@acm.org>
	<CAJZOPZKQ4rg6D=ZDt2q+aJbsNAQbgqgh19FmGC5Vi6_EQ4ROFQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJZOPZKQ4rg6D=ZDt2q+aJbsNAQbgqgh19FmGC5Vi6_EQ4ROFQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sat, Dec 17, 2011 at 5:03 PM, Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrot=
e:
> Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org> wrote:
>
>> The default block layer timeout is 30 seconds.
>
> Could you provider a pointer to where this is defined?

Sorry, it's not the block layer but sd (SCSI disk) that sets that
timeout value. From drivers/scsi/sd.h: #define SD_TIMEOUT (30 * HZ)

>> Typical values for the QP local ack
>> timeout and retry count are 19 and 7 respectively, which means
>> that it can take up to 60.1 seconds before a HCA submits an error co=
mpletion.
>
> isn't timeout(R,X) =3D R * ~4us * 2^X =A0=3D=3D> timeout(7,19) =3D 7 =
* ~2seconds
> =3D ~14 seconds

I started looking at the timeout settings after I noticed while
performing cable pulling tests with an mlx4-controlled HCA that it
could take up to (about) 61 seconds before an error completion was
delivered. And it looks like Dave already answered the question where
the factor four comes from ?

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
