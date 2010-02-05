From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: bug 1918 - openmpi broken due to rdma-cm changes
Date: Fri, 05 Feb 2010 10:38:39 -0600
Message-ID: <4B6C498F.3060708@opengridcomputing.com>
References: <58D723FE08DC6A4398E6596E38F3FA170566DA@XMB-RCD-205.cisco.com> <0D5487526204477AA2ABED06E46768E2@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <0D5487526204477AA2ABED06E46768E2-Zpru7NauK7drdx17CPfAsdBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "'Jeff Squyres (jsquyres)'" <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ewg-G2znmakfqn7U1rindQTSdQ@public.gmane.org, "Roland Dreier (rdreier)" <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Sean Hefty wrote:
>> Also note that trying to bind rdma cm to all interface ip addresses was the way
>> that we were advised by openfabrics to figure out which devices are rdma-
>> capable.
>>
>> As such, it is highly desirable to get the fix transparently in rdmacm and
>> preserve the old semantic. More specifically, it seems undesirable to change
>> this semantic in a minor ofed point release.
>>     
>
> I think the issue is larger than just the rdma_cm.
>
> First, it sounds like openmpi tries to bind to 127.0.0.1, which now works.  If
> opemmpi uses shared memory for connections on the same machine, I'm not sure why
> this is a problem, unless it is passing that address to another machine to use
> for a connection.  If this is the case, then that is a bug in openmpi.
>   

Yes, OpenMPI incorrectly advertises 127.0.0.1 as a valid address 
to-which the peer can connect. This needs to be fixed.


> Second, I still don't understand whether iwarp is limited to 'loopback'
> connections that are not bound to 127.0.0.1.  For instance, if the RDMA device
> is associated with 192.168.0.1, then can it handle a connection from 192.168.0.1
> <-> 192.168.0.1?  If it can't, then the rdma_cm can't help in this case when
> bind is called.  The failure has to come during connect, which sounds like the
> behavior that's seen today with 127.0.0.1.
>   

Its not iWARP specific.  A device may or may not support hw loopback.    
Now the IB spec mandates this support, but the iWARP spec doesn't.  
Ammasso and Chelsio T3 rnics do not support HW loopback.  They will fail 
if you try to connect to a local address.  The rdma-cm shouldn't allow 
binds to 127.0.0.1 for these devices since it 100% implies that the 
connection will require hw loopback for that device.

> So, while the rdma_cm can fail binds to 127.0.0.1 if the RDMA device doesn't
> support loopback, I'm still not sure how much of a fix this is.
>   

My concern is breaking an existing working OpenMPI in a point release 
because we changed semantics of the rdma-cm in an ofed point release...

BTW:  Was this change an artifact of rebasing ofed-1.5.1 on a new kernel 
version?

Steve.

> - Sean
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>   

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
