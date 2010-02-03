From: Eli Dorfman <dorfman.eli-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: opensm: suggestion to define new common port_groups file
Date: Wed, 3 Feb 2010 17:55:21 +0200
Message-ID: <694d48601002030755g5a567e78o56dd53151442607@mail.gmail.com>
References: <4B69453E.4080701@gmail.com> <4B694919.1000207@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4B694919.1000207-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
Cc: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Feb 3, 2010 at 11:59 AM, Yevgeny Kliteynik
<kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:
> On 03/Feb/10 11:43, Eli Dorfman (Voltaire) wrote:
>>
>> Currently there is a duplication of port group definition in OpenSM
>> configuration files.
>> Using a single configuration file for port groups will make it easie=
r to
>> manage and will allow using group name as keyword in other configura=
tion
>> files (i.e. partitions.conf, qos-policy.conf and opensm.conf)
>>
>> The suggested format for port-groups.conf is a simple list:
>> GroupA: GUID1, GUID2, GUID3
>> GroupB: GUID4, GUID5, GUID6
>>
>> All configuration files shall still support the old format (of speci=
fying
>> GUIDs explicitly) and will also recognize the new Groups.
>
> I'm all for it!
>
>>
>> Following an example of partitions.conf file with new group definiti=
on:
>> management=3D0x7fff,ipoib,defmember=3Dfull: GroupA=3Dfull, GroupB=3D=
limited,
>> ALL_CAS=3Dlimited;
>>
>> and qos-policy.conf with the new group definition:
>>
>> port-groups
>> =C2=A0 =C2=A0 port-group
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 port-guid: GroupA, GroupB
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 name: my.group
>> =C2=A0 =C2=A0 end-port-group
>> end-port-groups
>
> Perhaps in qos-policy.conf we should be able to reference
> GroupA and GroupB directly by its name, w/o the need to
> create additional group like it is shown in the example.

We can start with the simple suggestion as shown in the example and
then enhance as you suggest.

>
> Ideally, port-groups.conf parser should be able to
> understand various keywords, such as what is used in
> partitions.conf (ALL, SWITCHES, SELF, etc).
>
> To complicate port-groups.conf parser a bit more, it would
> be nice if it could support nested definition of port groups.
>
> But no need to do it right away, we can start with something
> simple.

I agree.

Eli
>
> -- Yevgeny
>
>>
>> Thanks,
>> Eli
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-rdma=
" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.h=
tml
>>
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
