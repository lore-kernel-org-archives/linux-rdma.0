From: Garrett Cooper <yanegomi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] [RFC] osm_log printing incorrectly assumes that pthread_t is not opaque type
Date: Sun, 9 Dec 2012 02:03:49 -0800
Message-ID: <477ACFD8-70C4-4D75-A5FB-27181C658A58@gmail.com>
References: <alpine.BSF.2.00.1212090125590.64779@toaster.local> <50C45FE8.5020502@acm.org>
Mime-Version: 1.0 (Apple Message framework v1283)
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <50C45FE8.5020502-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Dec 9, 2012, at 1:54 AM, Bart Van Assche wrote:

> On 12/09/12 10:26, Garrett Cooper wrote:
>> +#if defined(__FreeBSD__)
>> +            "%s %02d %02d:%02d:%02d %06d [%p] 0x%02x -> %s",
>> +#else
>>              "%s %02d %02d:%02d:%02d %06d [%04X] 0x%02x -> %s",
>> +#endif
>=20
> Please cast the pthread_t value to an unsigned long long or another i=
ntegral type. Such #ifdefs are a pain to maintain.

	I was fishing for an answer as to what the proper fix would be. I hate=
 hacking in #ifdefs if there's a better way to do things (Net-SNMP/Perl=
 are perfect examples of #ifdefs gone wrong).
	pthread_t is implemented as a pointer to a structure on FreeBSD, but t=
he address is not even guaranteed to be unique (there's a less document=
ed syscall for grabbing the thread id on FreeBSD, but I figured that pe=
ople on the list didn't want me to go programming FreeBSDisms into open=
sm :)=85). The fact of the matter is that POSIX says that the type shou=
ld be assumed to be opaque and the problem with the examples I've provi=
ded in osm_log.c is that they don't honor the opaqueness.
Thanks,
-Garrett--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
