From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [RFC 0/8] Reliably generate large request from SRP
Date: Mon, 24 Jan 2011 17:14:00 +0100
Message-ID: <AANLkTikapxELx5B6knAm6CQaeLsKHWd9EMQeexmFdF1Q@mail.gmail.com>
References: <1295411242-26148-1-git-send-email-dillowda@ornl.gov>
 <aday66hxxwe.fsf@cisco.com> <4D3805C4.6010203@voltaire.com>
 <1295528044.22825.64.camel@obelisk.thedillows.org> <4D3D9B74.8090607@voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4D3D9B74.8090607-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Jan 24, 2011 at 4:32 PM, Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org> wro=
te:
> David Dillow wrote:
>>> if we look on the 50% for SAS/1M IOs that you're presenting, can yo=
u tell
>>> what made the difference, srp went from sg_tablesize of 255 to 256 =
so the
>>> upper layers where able to provide 1M as one IO
>
>> This win is from sg_tablesize going from 255 to 256 in this case; th=
e HW
>> really likes that better than getting two requests -- one for 1020 K=
B
>> and one for 4 KB.
>
> Its always nice to find the simplest explanation to the greatest impr=
ovement... going to the 2nd largest gains
>
>> SAS =A0 2M =A0 =A0 =A0520 MB/s =A0 =A0 =A0 =A0861 MB/s
>> SAS =A0 4M =A0 =A0 =A0529 MB/s =A0 =A0 =A0 =A0921 MB/s
>> SAS =A0 8M =A0 =A0 =A0600 MB/s =A0 =A0 =A0 =A0951 MB/s
>
> I wonder what made the difference here? it can't be only the 255 --> =
256 sg_tablesize change, for the 2M case
> the change to use 512 pages FMRs could let you use one rkey/fmr for t=
he whole IO but not for 4M/8M

I think it would be interesting to have performance measurements with
a RAM disk as target too because it is hard to tell for someone not
familiar with the internals of the target used in this test which
performance gain is due to the initiator changes and which is due to
the target behavior.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
