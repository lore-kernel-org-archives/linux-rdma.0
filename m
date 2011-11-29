From: Marc Aurele La France <tsi@ualberta.ca>
Subject: Re: RCU'ed dst_get_neighbour()
Date: Tue, 29 Nov 2011 14:00:44 -0700 (Mountain Standard Time)
Message-ID: <alpine.WNT.2.00.1111291359290.1036@TSI>
References: <alpine.WNT.2.00.1111291027320.1036@TSI> <1322589661.2596.2.camel@edumazet-laptop> <1322599437.2596.10.camel@edumazet-laptop> <CAG4TOxNJfr3X1p358LBWdNQKdkw8KOSekcKpNu6K5_phPEiR4A@mail.gmail.com> <1322599991.2596.11.camel@edumazet-laptop>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="17891750-19608-1322600445=:1036"
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1322599991.2596.11.camel@edumazet-laptop>
Sender: netdev-owner@vger.kernel.org
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Roland Dreier <roland@kernel.org>, David Miller <davem@davemloft.net>, netdev@vger.kernel.org, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--17891750-19608-1322600445=:1036
Content-Type: TEXT/PLAIN; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT

On Tue, 29 Nov 2011, Eric Dumazet wrote:

> Le mardi 29 novembre 2011 à 12:47 -0800, Roland Dreier a écrit :
>> Thanks Eric, I'll send this to Linus shortly.

> Oh well, I forgot one rcu_read_unlock(), I'll send a V2...

This also doesn't address the other dst_get_neighbour() instances 
introduced by 
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=commitdiff;h=69cce1d1404968f78b177a0314f5822d5afdbbfb

Marc.

+----------------------------------+----------------------------------+
|  Marc Aurele La France           |  work:   1-780-492-9310          |
|  Academic Information and        |  fax:    1-780-492-1729          |
|    Communications Technologies   |  email:  tsi@ualberta.ca         |
|  352 General Services Building   +----------------------------------+
|  University of Alberta           |                                  |
|  Edmonton, Alberta               |    Standard disclaimers apply    |
|  T6G 2H1                         |                                  |
|  CANADA                          |                                  |
+----------------------------------+----------------------------------+
--17891750-19608-1322600445=:1036--
