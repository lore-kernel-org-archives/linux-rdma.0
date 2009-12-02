From: Arputham Benjamin <abenjamin-sJ/iWh9BUns@public.gmane.org>
Subject: Proposal to add a name to an IB subnet
Date: Wed, 02 Dec 2009 15:59:00 -0800
Message-ID: <4B16FF44.7090507@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>, hnrose-Wuw85uim5zDR7s880joybQ@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi,

I suggest we add a text based name to an IB subnet, perhaps to
help user in identifying an IB subnet or understanding its function
in a multi-fabric IB cluster. For example, in a dual-fabric
(or dual-rail) IB cluster, one subnet could be named "mpi" and the
other subnet could be named "storage".

In the current implementation of OpenSM, syslog messages are prefixed
with the process ID. When multiple instances of OpenSM run on a single node
to support dual-fabric IB, process ID doesn't help the admin to quickly 
identify a specific IB subnet (i.e., it needs a translation)

subnet_prefix (64-bit number) can be used as a prefix to syslog messages
but a user configurable text based name is better.

We could add an option '-n | --ib_subnet_name' to OpenSM command line
to input the IB subnet name and modify the osm_log() function for syslog
messages (message type: OSM_LOG_SYS) to prefix its messages with the
subnet name. 

Also, we could limit this name prefix changes to syslog messages only for now.
(i.e., leave the opensm log as it is because the current implementation
allows the user to specify the file name for the opensm log)

Any comments?

Regards,
Benjamin
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
