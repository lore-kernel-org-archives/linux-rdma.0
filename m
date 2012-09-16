From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH] /etc/init.d/opensmd: Improve systemd integration
Date: Sun, 16 Sep 2012 14:22:11 +0200
Message-ID: <5055C473.5050401@acm.org>
References: <50535650.6050306@acm.org> <20120916093159.GB8243@calypso>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120916093159.GB8243@calypso>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 09/16/12 11:31, Alex Netes wrote:
> Hi Bart,
>
> On 18:07 Fri 14 Sep     , Bart Van Assche wrote:
>> On recent SLES and openSUSE systems it is necessary to read the
>> file /lib/lsb/init-functions instead of /etc/rc.status for proper
>> integration with systemd. Also, prevent that the opensm process is
>> started twice and drop /var/lock/subsys/opensm.
>
> There could be a problem (which also persists in the original script), that in
> theory you can run two OpenSM instances (on different ports) which is not
> being supported by the init script. Any thoughts how this can be addressed?

How about following the same approach as for srp_daemon: modify 
/etc/init.d/opensm such that it starts a script that starts the opensm 
process on all ports on which it should be started ?

Bart.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
