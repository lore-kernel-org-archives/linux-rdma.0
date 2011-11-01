From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: cq error timeout issue
Date: Tue, 01 Nov 2011 10:04:55 -0400
Message-ID: <4EAFFC87.70208@dev.mellanox.co.il>
References: <CAFAcbYPXqcOc79fcWHK7iHkfEX0ecmg4CBSUgUk=C=xiScSRRw@mail.gmail.com> <1828884A29C6694DAF28B7E6B8A8237316E8B236@ORSMSX101.amr.corp.intel.com> <CAFAcbYNJFH0n=gFwki0uLUzDd6cu7MxuHR99x9i9wUY3xp+Hdg@mail.gmail.com> <CAJZOPZKr3Jz4r=bfN18HRH7My_8haw+XtJznk7R5N92ZZn4=4Q@mail.gmail.com> <CAFAcbYOsaAVumnRQu_MYvH1-RL1gB+9_-GApPHSdJ_2E4H_j4Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAFAcbYOsaAVumnRQu_MYvH1-RL1gB+9_-GApPHSdJ_2E4H_j4Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vlad Weinbaum <vlad.weinbaum-adSD+vzF2QdBDgjK7y7TUQ@public.gmane.org>
Cc: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Just to clarify:

On 11/1/2011 9:25 AM, Vlad Weinbaum wrote:
> packet_life_time is 12 in sm.conf.

OpenSM packet_life_time setting has nothing to do with this (but is used
for SwitchInfo:LifeTimeValue setting):

# The code of maximal time a packet can live in a switch
# The actual time is 4.096usec * 2^<packet_life_time>
# The value 0x14 disables this mechanism

The rate in SA PathRecord comes from subnet timeout in the absence of QoS:
        /*
         * Set packet lifetime.
         * According to spec definition IBA 1.2 Table 205
         * PacketLifeTime description, for loopback paths,
         * packetLifeTime shall be zero.
         */
        if (p_src_port == p_dest_port)
                pkt_life = 0;
        else if (p_qos_level && p_qos_level->pkt_life_set)
                pkt_life = p_qos_level->pkt_life;
        else
                pkt_life = sa->p_subn->opt.subnet_timeout;

-- Hal

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
