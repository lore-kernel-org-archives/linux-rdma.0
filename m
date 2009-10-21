From: stuarts <stuarts-dK3M3PVJaX4iXRBKUn1UN0EOCMrvLtNR@public.gmane.org>
Subject: Re: Multicast joins failing on 1.5-rc1?
Date: Wed, 21 Oct 2009 14:16:47 -0500
Message-ID: <C28CB83A-CF52-4603-91DF-D56865CBEA98@routingdynamics.com>
References: <A5E1097A-DFEA-4508-A47F-FF07C34EA525@routingdynamics.com> <f0e08f230910201152g476383ffp8e7392dc0c48e41@mail.gmail.com>
Mime-Version: 1.0 (Apple Message framework v1076)
Content-Type: text/plain; charset=iso-8859-1;
	format=flowed	delsp=yes
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <f0e08f230910201152g476383ffp8e7392dc0c48e41-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


On Oct 20, 2009, at 1:52 PM, Hal Rosenstock wrote:

> On Tue, Oct 20, 2009 at 2:16 PM, stuarts =20
> <stuarts-dK3M3PVJaX4iXRBKUn1UN0EOCMrvLtNR@public.gmane.org> wrote:
>
> <snip...>
>
>> When I looked closer, I can see that I get an error -22 on the =20
>> multicast
>> joins (using a qlogic switche's SM) for everything _except_ the =20
>> broadcast
>> join.  I switched over to opensm, since it has far better debugging
>> abilities and see the same behavior, though the error code is =20
>> opensm logs a
>> message with error 1B11.
>>
>> When I look through for the code, I found that error code =20
>> associated with an
>> invalid set of component masks:
>> Oct 20 12:40:05 824130 [44240940] 0x01 -> mcmr_rcv_join_mgrp: ERR =20
>> 1B11:
>> method =3D SubnAdmSet, scope_state =3D 0x1, component mask =3D =20
>> 0x0000000000010083,
>> expected comp mask =3D 0x00000000000130c7, MGID: ff12:601b:ffff::16 =
=20
>> from port
>> 0x0002c90300032431 (x3 HCA-1)
>
> This is join behavior when the group is not (previously) created (by
> some full member). Any idea what was creating this group before ?

Hal (and Jason):

Thanks for the responses. Yes, it appears the problem is in the "other =
=20
side" of the sender/receiver pairing.

I did a lot more tracing on the sender side. I think I see what is =20
happening: The sender uses the IP_ADD_MEMBERSHIP socket op. The IP =20
stack (via the dev->mc_list multicast list) tries to create the =20
following MGIDs:
ff12:401b:ffff:0000:0000:0000:0100:0025
ff12:601b:ffff:0000:0000:0000:0000:00fb
ff12:601b:ffff:0000:0000:0001:ff03:2431
ff12:601b:ffff:0000:0000:0000:0000:0001
ff12:401b:ffff:0000:0000:0000:0000:0001
ff12:401b:ffff:0000:0000:0000:0000:00fb

The first one is mine, and the others are in the admin band (***1 is =20
all-hosts, for example).

This looks like it is valid, BUT, the call to =20
ipoib_mcast_addr_is_valid occurs BEFORE the pkey is folded in from the =
=20
ipoib_dev_priv structure. Printing out the pre-fold-in values shows:
00ffffffff12601b0000000000000000000000fb

(This is the dev_mc_list -> dmi_addr value)

Oops, that pkey is "wrong" (0 vs ffff). Out this address goes!

When the broadcast mgid gets created, it is created with the pkey from =
=20
ipoib_dev_priv structure and is thus ffff, not 000. None of the new =20
groups ever make it past the bad mcast check and my sender always =20
fails because the groups don't exist in the SM.

If I disable the check so all of these "bad" addresses get added, I am =
=20
up and running.

What is the best course of action at this point? Presuming I am not =20
missing something obvious, I am not seeing any way to do this cleanly =20
with what I know: folding in the pkey earlier would be the exact same =20
things as _not_ checking the pkey. Annnnd, I don't think the stuff =20
higher up the stack knows the pkey value(I have not looked though, so =20
I that is just gut-feel). Open a bug? I'll be happy to do the work and =
=20
provide a patch, though I only have the RHEL5.4 system to test against =
=20
(and only just figured out how to build my own modules this morning).

Thanks, --stuart

Mcast transmitter and receiver example included below, cribbed from =20
the example by Antony Courtney. Sorry for the hardcoded bond0 =20
addresses in the middle there.

/*
  * listener.c -- joins a multicast group and echoes all data it =20
receives from
  *		the group to its stdout...
  *
  * Antony Courtney,	25/11/94
  * Modified by: Fr=E9d=E9ric Bastien (25/03/04)
  * to compile without warning and work correctly
  */

#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <time.h>
#include <string.h>
#include <stdio.h>


#define HELLO_PORT 12345
#define HELLO_GROUP "225.0.0.37"
#define MSGBUFSIZE 256

main(int argc, char *argv[])
{
      struct sockaddr_in addr;
      int fd, nbytes,addrlen;
      struct ip_mreq mreq;
      char msgbuf[MSGBUFSIZE];

      u_int yes=3D1;            /*** MODIFICATION TO ORIGINAL */

      /* create what looks like an ordinary UDP socket */
      if ((fd=3Dsocket(AF_INET,SOCK_DGRAM,0)) < 0) {
	  perror("socket");
	  exit(1);
      }


/**** MODIFICATION TO ORIGINAL */
     /* allow multiple sockets to use the same PORT number */
     if (setsockopt(fd,SOL_SOCKET,SO_REUSEADDR,&yes,sizeof(yes)) < 0) {
        perror("Reusing ADDR failed");
        exit(1);
        }
/*** END OF MODIFICATION TO ORIGINAL */

      /* set up destination address */
      memset(&addr,0,sizeof(addr));
      addr.sin_family=3DAF_INET;
      addr.sin_addr.s_addr=3Dhtonl(INADDR_ANY); /* N.B.: differs from =20
sender */
      //addr.sin_addr.s_addr =3D 0xa2fca8c0;
      addr.sin_port=3Dhtons(HELLO_PORT);

      /* bind to receive address */
      if (bind(fd,(struct sockaddr *) &addr,sizeof(addr)) < 0) {
	  perror("bind");
	  exit(1);
      }

      /* use setsockopt() to request that the kernel join a multicast =20
group */
      mreq.imr_multiaddr.s_addr=3Dinet_addr(HELLO_GROUP);
      mreq.imr_interface.s_addr=3D0xa2fca8c0;
      if (setsockopt(fd,IPPROTO_IP,IP_ADD_MEMBERSHIP,&mreq,sizeof=20
(mreq)) < 0) {
	  perror("setsockopt");
	  exit(1);
      }

      /* now just enter a read-print loop */
      while (1) {
	  addrlen=3Dsizeof(addr);
	  if ((nbytes=3Drecvfrom(fd,msgbuf,MSGBUFSIZE,0,
			       (struct sockaddr *) &addr,&addrlen)) < 0) {
	       perror("recvfrom");
	       exit(1);
	  }
	  puts(msgbuf);
      }
}

/*
  * sender.c -- multicasts "hello, world!" to a multicast group once a =
=20
second
  *
  * Antony Courtney,	25/11/94
  */

#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <time.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <errno.h>

#define HELLO_PORT 12345
#define HELLO_GROUP "225.0.0.37"

main(int argc, char *argv[])
{
      struct sockaddr_in addr;
      int fd, cnt;
      struct ip_mreq mreq;
      char *message=3D"Hello, World!";
      struct in_addr interface_addr;
     int er;

      /* create what looks like an ordinary UDP socket */
      if ((fd=3Dsocket(AF_INET,SOCK_DGRAM,0)) < 0) {
	  perror("socket");
	  exit(1);
      }
     interface_addr.s_addr =3D htonl(0xa2fca8c0);
     interface_addr.s_addr =3D 0xa1fca8c0;
     er=3Dsetsockopt (fd, IPPROTO_IP, IP_MULTICAST_IF, &interface_addr,=
 =20
sizeof(interface_addr));
     printf("er=3D%d, errno=3D%d\n", er, errno);

      /* set up destination address */
      memset(&addr,0,sizeof(addr));
      addr.sin_family=3DAF_INET;
      addr.sin_addr.s_addr=3Dinet_addr(HELLO_GROUP);
      addr.sin_port=3Dhtons(HELLO_PORT);

      /* now just sendto() our destination! */
      while (1) {
	  if (sendto(fd,message,sizeof(message),0,(struct sockaddr *) &addr,
		     sizeof(addr)) < 0) {
	       perror("sendto");
	       exit(1);
	  }
	  sleep(1);
      }
}

--
Stuart Stanley
M: 952-457-3790
stuarts-dK3M3PVJaX4iXRBKUn1UN0EOCMrvLtNR@public.gmane.org
--
"The avalanche has started. It is too late for the pebbles to vote." - =
=20
Kosh in Babylon 5:"Believers"

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
