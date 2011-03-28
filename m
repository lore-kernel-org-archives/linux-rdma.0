From: Konstantin Boyanov <konstantin.boyanov-T5F83Mi6MZE@public.gmane.org>
Subject: Re: Segmentation Fault when accessing QPN of a RC Queue pair
Date: Mon, 28 Mar 2011 12:57:23 +0200
Message-ID: <4D906993.7030404@desy.de>
References: <4D89EDC4.4050309@desy.de>	<CF9C39F99A89134C9CF9C4CCB68B8DDF25DC282B5C@orsmsx501.amr.corp.intel.com> <AANLkTi=ppeQSxHTA18pFM6=y06Q_eNGsY8Fn=gXtXaBM@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTi=ppeQSxHTA18pFM6=y06Q_eNGsY8Fn=gXtXaBM-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Konstantin Boyanov <kkboyanov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Sorry for the last incomplete mail, I accidentaly pressed the enter when 
in the wrong focus...
here we go again:

Hello,

First of all thanks for the reply! I was really getting desperate about 
this issue.

I have looked in the libibverbs examples and I cannot see differences 
between my code and the one in the examples (at least functionally, I 
clearly have another structure in my programm).

About the snippets: I didn't want to copy/paste all the code into my 
mail, that's why I provided a link to where the code can be found:


http://www.ifh.de/~boyanov/ibpipo/ <http://www.ifh.de/%7Eboyanov/ibpipo/>


I still cannot understand what I am doing wrong, and why the errors ocur 
only on one of the Queue Pairs. Is it possible that I try to interact 
with some of the "reserved" QPs like the QP0 and QP1?

Another thing: I am also getting segfaults when trying to modify the LID 
of the QP contexts. i first get the LID from the device and then when 
trying to set it in my custom QP context structure I get a segfault:

      struct ibv_port_attr tmp_port_attr;

      ret = ibv_query_port(ping_ib_thread.ibctx, barg.port, &tmp_port_attr);
      if ( ret != 0){
        printf("error querying IB port %d for context %s\n", port, 
ping_ib_thread.ibctx->device->dev_path);
        perror("ibv_query_port");
      }

    ping_ib_thread.ibport_attr->lid = tmp_port_attr.lid;
    pong_ib_thread.ibport_attr->lid = tmp_port_attr.lid;

Here, barg.port = 1 and port 1 is in the PORT_ACTIVE state.  I know I am 
missing something small but I am so confused and frustrated from this 
code I cannot see anything anymore in it...

Please, if you have some clues to what can be wrong, at least where I 
can dig for more info and possible problems, let me know.

Best Regards,
Konstantin
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
