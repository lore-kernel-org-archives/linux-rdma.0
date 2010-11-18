From: "King, Perry E." <perry.king-itBhTGHPdi0@public.gmane.org>
Subject: memory leak in libdat2.so.2.0.0
Date: Thu, 18 Nov 2010 15:34:03 -0600
Message-ID: <383353BE0FE2954EBF88EDAF1402144D035B6BD5@XMBIL153.northgrum.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-class: urn:content-classes:message
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: "Young, Eric R." <Eric.Young-itBhTGHPdi0@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi,
I assume I am writing to the correct address.=A0 I would like to report=
 a memory leak in libdat2.so.2.0.0 that I noticed while using valgrind.

I isolated it to an application that does not actually make any calls o=
n libdat2.=A0 All it does is link it in with g++ using -ldat2.

I am running on Fedora 12 and using export LD_DEBUG=3D"libs" I could se=
e that when my program ran, the loader was calling init on the library =
at startup and fini at the end.

Again, I am not making any calls on the library, merely linking it in (=
as a test, I linked it into an application that did not previously use =
it).

Even so, I see the following:


=3D=3D14551=3D=3D 14 bytes in 14 blocks are definitely lost in loss rec=
ord 47 of 285
=3D=3D14551=3D=3D=A0=A0=A0 at 0x4A0515D: malloc (vg_replace_malloc.c:19=
5)
=3D=3D14551=3D=3D=A0=A0=A0 by 0x6FE49B2: dat_sr_get_token (dat_osd.h:22=
6)
=3D=3D14551=3D=3D=A0=A0=A0 by 0x6FE5206: dat_sr_parse_entry (udat_sr_pa=
rser.c:706)
=3D=3D14551=3D=3D=A0=A0=A0 by 0x6FE5508: dat_sr_load (udat_sr_parser.c:=
268)
=3D=3D14551=3D=3D=A0=A0=A0 by 0x6FE7FB5: dat_sr_init (dat_sr.c:84)
=3D=3D14551=3D=3D=A0=A0=A0 by 0x6FE74E9: dat_init (dat_init.c:117)
=3D=3D14551=3D=3D=A0=A0=A0 by 0x6FE7FF5: ??? (in /usr/lib64/libdat2.so.=
2.0.0)
=3D=3D14551=3D=3D=A0=A0=A0 by 0x6FE3B1A: ??? (in /usr/lib64/libdat2.so.=
2.0.0)
=3D=3D14551=3D=3D=20
=3D=3D14551=3D=3D 4,944 (4,592 direct, 352 indirect) bytes in 14 blocks=
 are definitely lost in loss record 270 of 285
=3D=3D14551=3D=3D=A0=A0=A0 at 0x4A0515D: malloc (vg_replace_malloc.c:19=
5)
=3D=3D14551=3D=3D=A0=A0=A0 by 0x6FE7D4E: dat_sr_insert (dat_osd.h:226)
=3D=3D14551=3D=3D=A0=A0=A0 by 0x6FE547E: dat_sr_parse_entry (udat_sr_pa=
rser.c:343)
=3D=3D14551=3D=3D=A0=A0=A0 by 0x6FE5508: dat_sr_load (udat_sr_parser.c:=
268)
=3D=3D14551=3D=3D=A0=A0=A0 by 0x6FE7FB5: dat_sr_init (dat_sr.c:84)
=3D=3D14551=3D=3D=A0=A0=A0 by 0x6FE74E9: dat_init (dat_init.c:117)
=3D=3D14551=3D=3D=A0=A0=A0 by 0x6FE7FF5: ??? (in /usr/lib64/libdat2.so.=
2.0.0)
=3D=3D14551=3D=3D=A0=A0=A0 by 0x6FE3B1A: ??? (in /usr/lib64/libdat2.so.=
2.0.0)

I assume this is happening when libdat2.so is initialized, but no corre=
sponding free is happening when the loader calls its fini function (or =
destructor).=A0 So I thought I would report it.

Thank you,

Perry King
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
