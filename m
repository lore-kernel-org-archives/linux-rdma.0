From: "Eli Dorfman (Voltaire)" <dorfman.eli-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: opensm: suggestion to define new common port_groups file
Date: Wed, 03 Feb 2010 11:43:26 +0200
Message-ID: <4B69453E.4080701@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Currently there is a duplication of port group definition in OpenSM configuration files.
Using a single configuration file for port groups will make it easier to manage and will allow using group name as keyword in other configuration files (i.e. partitions.conf, qos-policy.conf and opensm.conf)

The suggested format for port-groups.conf is a simple list:
GroupA: GUID1, GUID2, GUID3
GroupB: GUID4, GUID5, GUID6

All configuration files shall still support the old format (of specifying GUIDs explicitly) and will also recognize the new Groups.

Following an example of partitions.conf file with new group definition:
management=0x7fff,ipoib,defmember=full: GroupA=full, GroupB=limited, ALL_CAS=limited;

and qos-policy.conf with the new group definition:

port-groups
    port-group
        port-guid: GroupA, GroupB
        name: my.group
    end-port-group
end-port-groups


Thanks,
Eli
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
