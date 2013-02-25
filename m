From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: srptools ("Virtual" ibnetdiscover command fails)
Date: Mon, 25 Feb 2013 19:46:30 +0100
Message-ID: <512BB186.8030305@acm.org>
References: <CAOoYFkFw-0WDYt6gQ-t0V6QaV8p7qraYrMbA-NxeiPVfUy2Bkg@mail.gmail.com> <201302052134.17622.jackm@dev.mellanox.co.il> <CAOoYFkF_nE4JNg2ooKXHyO2jqQkjOyczqmBHSehZHtS2tBEFLQ@mail.gmail.com> <511220EA.4020607@mellanox.com> <CAOoYFkHArx4_eH90ehaPupCkXyRjO4KzZ7CGkXkqGm3kSWJfKA@mail.gmail.com> <CAOoYFkEWkxMOsU2VejmYXXcpQY3+LxJCHpBswh6L6fTJgwoe1A@mail.gmail.com> <51122E7D.3030607@mellanox.com> <5112332B.6090200@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5112332B.6090200-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 02/06/13 11:40, Sebastian Riemer wrote:
> On 06.02.2013 11:20, Or Gerlitz wrote:
>> On 06/02/2013 12:04, Mathis GAVILLON wrote:
>>> Just a last question : is that possible VFs lid to be different from
>>> PF one ?
>>
>> NO, we've implemented a "shared port" model, so all functions on the
>> same IB port use the same lid, each function has its own
>> virtual GUID though.
>
> So if I don't use the unmaintained srptools to get the SRP connection
> strings but instead send them directly to the initiator to connect to
> the SRP target, then also SRP should be possible with the virtual GUID.
> Am I right?

It would be appreciated it if someone would step forward and would 
propose to maintain the srptools package. In the meantime, an update for 
srptools 0.4 can be found here: http://github.com/bvanassche/srptools. 
The user-visible changes compared to version 0.4 are:
- srp_daemon keeps working even if the LID changes of the port it is
   using to scan the fabric or if a P_Key change occurs. In other words,
   it is no longer necessary to restart srp_daemon after an IB cable has
   been plugged.
- Added P_Key support to srp_daemon and ibsrpdm.
- Fixed month in srp_daemon.log (OFED bug #2281). srp_daemon now uses
   syslog and logrotate for logging.
- srp_daemon is now only started in InfiniBand ports. It is no longer
   attempted to start srp_daemon on Ethernet ports.
- Fixed a memory leak in srp_daemon that was triggered once during
   every fabric rescan.
- Reduced memory consumption of the srp_daemon process.
- srp_daemon skips now MAD transaction ID 0 after 2**32 rescans.
- Installation: SRPHA_ENABLE=no / SRP_DAEMON_ENABLE=no is only added to
   /etc/infiniband/openibd.conf if these variables did not yet exist in
   that file.
- Changed range of the srp_daemon and ibsrpdm exit codes from 0..127
   into 0..1.
- Changed ibsrpdm such that it uses RMPP.
- Changed ibsrpdm such that it uses the new umad P_Key ABI. Running
   ibsrpdm does no longer cause a warning to be logged ("user_mad:
   process ibsrpdm did not enable P_Key index support / user_mad:
   Documentation/infiniband/user_mad.txt has info on the new ABI").
- Fixed spelling of several help texts and diagnostic messages.

As usual, feedback is welcome.

Bart.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
