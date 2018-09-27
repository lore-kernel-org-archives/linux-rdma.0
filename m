From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH] IB/mlx4: Avoid implicit enumerated type conversion
Date: Thu, 27 Sep 2018 15:33:42 -0700
Message-ID: <1538087622.226558.8.camel@acm.org>
References: <20180924195716.30848-1-natechancellor@gmail.com>
         <CAKwvOdkr+ovYgmqWENHkCcAWMC+xC6NYne6SBycq_KXscpHxEQ@mail.gmail.com>
         <20180924222737.GA26973@flashbox>
         <CAKwvOdkZ-0k4BhXYz0wj3wXNyy95nKFe9aYXxXveLafuviGG2w@mail.gmail.com>
         <20180925023722.GA32600@ziepe.ca> <20180927010803.GA7640@flashbox>
         <20180927044826.GC24889@ziepe.ca>
         <CAKwvOdnmg2XY6K-8jTna3EKR1Nx04gOm6ZoywUwQO_CSANR_jg@mail.gmail.com>
         <20180927202849.GA11120@flashbox>
         <CAKwvOdnMOcdKPNHwKbcsg8rJX3_hDTgY752Nb4hgMC2D4p5aRg@mail.gmail.com>
         <20180927222821.GC28301@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-7"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180927222821.GC28301@ziepe.ca>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@ziepe.ca>, Nick Desaulniers <ndesaulniers@google.com>
Cc: Nathan Chancellor <natechancellor@gmail.com>, dledford@redhat.com, linux-rdma@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, 2018-09-27 at 16:28 -0600, Jason Gunthorpe wrote:
+AD4 On Thu, Sep 27, 2018 at 01:34:16PM -0700, Nick Desaulniers wrote:
+AD4 
+AD4 +AD4 +AD4 Neither ib+AF8-qp+AF8-create+AF8-flags nor mlx4+AF8-ib+AF8-qp+AF8-flags have negative values, is
+AD4 +AD4 +AD4 signedness necessary?
+AD4 +AD4 
+AD4 +AD4 enums are by default restricted to the range of ints.  
+AD4 
+AD4 That's not quite right, the compiler sizes the enum to be able to fit
+AD4 the largest value contained within, today that is int, but if we added
+AD4 1+ADwAPA-31, then it would become larger.

Hi Jason,

Are you perhaps confusing C and C+-+-? For C+-+-, an enumeration whose underlying
type is not fixed, the underlying type is an integral type that can represent
all the enumerator values defined in the enumeration. For C however I think
that enumeration values are restricted to what fits in an int.

Bart.
